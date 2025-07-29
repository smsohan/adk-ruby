module Adk
  module Ruby
    module Tools
      class Tool
        attr_accessor :name, :description, :parameters, :callable

        def initialize(name:, description:, parameters:, callable:)
          @name = name
          @description = description
          @parameters = parameters
          @callable = callable
        end

        def to_h
          {
            name: @name,
            description: @description,
            parameters: @parameters
          }
        end

      end
    end
  end
end