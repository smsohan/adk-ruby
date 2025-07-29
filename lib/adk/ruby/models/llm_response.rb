module Adk
  module Ruby
    module Models
      class LlmResponse
        attr_accessor :json_response
        def initialize(json_response:)
          @json_response = json_response
        end

        def text_parts
          @text_parts ||= @json_response["candidates"].map do |candidate|
            candidate["content"]["parts"].map do |part|
              part["text"]
            end
          end.flatten.compact
        end

        def text_part
          text_parts.first
        end

        def function_calls
          @function_calls_parts ||= @json_response["candidates"].map do |candidate|
            candidate["content"]["parts"].map do |part|
              part["functionCall"]
            end
          end.flatten.compact
        end

        def function_call
          function_calls.first
        end

        def id
          @json_response["responseId"]
        end

        def model_content_parts
          @json_response["candidates"][0]["content"]["parts"]
        end
      end
    end
  end
end