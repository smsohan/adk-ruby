module Adk
  module Ruby
    module Agents
      class Agent

        attr_accessor :name, :description, :model, :tools

        def initialize(name:, description:, model:, tools: [])
          @name = name
          @description = description
          @model = model
          @tools = tools
        end

        def run
          while true
            puts "[User]"
            message = gets
            model.generate_content(prompt: message, tools: @tools) do |response|
              puts response.json_response
              text, function_call = response.text_part, response.function_call

              if function_call
                result = call_function(function: function_call)
              end
            end
          end
        end

        def call_function(function:)
          tool = @tools.find{|tool| tool.name == function["name"]}
          sym_args = function["args"].transform_keys(&:to_sym)
          result = tool.callable.call(**sym_args)
        end

      end
    end
  end
end