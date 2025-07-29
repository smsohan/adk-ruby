module Adk
  module Ruby
    module Agents
      class Agent

        attr_accessor :name, :description, :model, :tools, :system_instruction

        def initialize(name:, description:, model:, tools: [], system_instruction: "")
          @name = name
          @description = description
          @model = model
          @tools = tools
          @system_instruction = system_instruction
        end

        def run
          contents = []
          while true
            puts "[User]"
            message = gets
            handle_prompt(prompt: message, contents: contents)
          end
        end

        private

        def call_function(function:)
          tool = @tools.find{|tool| tool.name == function["name"]}
          sym_args = function["args"].transform_keys(&:to_sym)
          result = tool.callable.call(**sym_args)
        end

        def handle_prompt(prompt:, contents:)
          if prompt
            contents << {parts: [{ text: prompt}], role: "user" }
          end

          model.generate_content(contents: contents, tools: @tools, system_instruction: @system_instruction) do |response|
            puts response.json_response
            contents << {parts: response.model_content_parts, role: "model"}

            text, function_call = response.text_part, response.function_call
            if function_call
              result = call_function(function: function_call)
              contents << function_calls_parts(id: response.id, function_call: function_call, result: result)
              handle_prompt(prompt: nil, contents: contents)
            end
            if text
              puts text
            end

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


      end
    end
  end
end