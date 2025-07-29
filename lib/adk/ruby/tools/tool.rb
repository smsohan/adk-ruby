module Adk
  module Ruby
    module Tools
      class Tool
        attr_accessor :name, :description, :parameters, :response, :callable

        def initialize(name:, description:, parameters:, response: nil, callable:)
          @name = name
          @description = description
          @parameters = parameters
          @callable = callable
          @response = response
        end

        def to_h
          {
            name: @name,
            description: @description,
            parameters: @parameters,
            response: @response
          }
        end

      end
    end
  end
end