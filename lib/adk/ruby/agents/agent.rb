module Adk
  module Ruby
    module Agents
      class Agent

        attr_accessor :name, :description, :model

        def initialize(name:, description:, model:)
          @name = name
          @description = description
          @model = model
        end

        def run()
          while true
            puts "[User]"
            message = gets
            puts model.generate_content(prompt: message)
          end
        end

      end
    end
  end
end