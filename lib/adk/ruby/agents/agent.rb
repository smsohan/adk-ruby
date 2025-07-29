require_relative '../tools/tool'
require_relative '../sessions/session'

module Adk
  module Ruby
    module Agents
      class Agent

        attr_accessor :name, :description, :model, :tools, :system_instruction, :sub_agents, :output_key

        def initialize(name:, description:, model:, tools: [], system_instruction: "", sub_agents: [], output_key: nil)
          @name = name
          @description = description
          @model = model
          @tools = tools
          @system_instruction = system_instruction
          @sub_agents = sub_agents

          unless @sub_agents.empty?
            @tools << transfer_agent_tool
            @system_instruction = [system_instruction,sub_agents_instruction].join("\n")
          end

          @session = Sessions::Session.instance
          @output_key = output_key
        end

        def system_instruction
          inst = @system_instruction
          inst.scan(/\{([^}]+)\}/).flatten.each do |variable|
            inst = inst.gsub("{#{variable}}", @session.outputs[variable])
          end
          inst
        end

        def tree(pad: "")
          s = [name]
          s += sub_agents.map{|c| "|-- #{c.tree(pad: pad + "  ")}"}

          @tools.each do |tool|
            s << "|-- #{tool.name} (Tool)"
          end

          s.join("\n#{pad}")
        end

        def handle_prompt(prompt:)
          if prompt
            @session.contents << {parts: [{ text: prompt}], role: "user" }
          end

          model.generate_content(contents: @session.contents, tools: @tools, system_instruction: system_instruction) do |response|
            # puts response.json_response
            @session.contents << {parts: response.model_content_parts, role: "model"}

            text, function_call = response.text_part, response.function_call
            if function_call
              result = call_function(function: function_call)
              return if function_call["name"] == "transfer_agent_tool"

              @session.contents << function_calls_parts(id: response.id, function_call: function_call, result: result)
              handle_prompt(prompt: nil)
              return
            end

            if text
              if @output_key
                @session.outputs[@output_key] = text
              end
              puts "[#{@name}] #{text}"
            end

          end
        end

        def to_s
          <<-STR
          Agent Name: #{@name}
          Agent Description: #{@description}
          STR
        end

        private

        def call_function(function:)
          tool = @tools.find{|tool| tool.name == function["name"]}
          sym_args = function["args"].transform_keys(&:to_sym)
          begin
            puts "[#{@name}] Calling function #{function["name"]}(#{function["args"]})"
            result = tool.callable.call(**sym_args)
          rescue Exception => error
            puts "Error calling function: #{error}"
            result = error.message
          end
        end

        def function_calls_parts(id:, function_call:, result:)
          {
            parts:
            [{
              functionResponse: {
                id: id,
                name: function_call["name"],
                response: {
                  output: result
                }
              }
            }],
            role: "function"
          }
        end

        def sub_agents_instruction
          <<-INSTR
          You have a list of other agents you can transfer to:
          #{@sub_agents.map(&:to_s).join("\n")}

          If you can answer it or use the available tools, answer directly.

          Otherwise, call the `transfer_agent_tool` function to transfer to another agent.
          INSTR
        end

        def transfer_agent_tool
          Tools::Tool.new(
            name: 'transfer_agent_tool',
            description: 'Transfers the conversation to another agent',
            parameters: {
              type: 'object',
              properties: {
                agent_name: {
                  type: 'string',
                  description: 'The name of the agent to transfer to'
                }
              },
              required: ['agent_name']
            },
            callable: ->(agent_name:) {
              puts "[#{@name}] Calling another agent: #{agent_name} with prompt: #{@session.last_user_prompt}"
              agent = sub_agents.find{|agent| agent.name == agent_name}
              agent.handle_prompt(prompt: @session.last_user_prompt)
            }
          )
        end

      end

    end
  end
end