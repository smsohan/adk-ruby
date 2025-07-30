require 'logger'
require 'net/http'
require 'json'
require_relative './llm_response'

module Adk
  module Ruby
    module Models
      class Gemini

        attr_accessor :name
        def initialize(name:)
          @name = name
        end

        def generate_content(contents:, tools:, system_instruction:)
          url = "https://generativelanguage.googleapis.com/v1beta/models/#{@name}:generateContent?key=#{ENV['GEMINI_API_KEY']}"
          uri = URI(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path + "?" + uri.query)
          request['Content-Type'] = 'application/json'
          body = {
            contents: contents,
            tools: tools_as_json(tools: tools)
          }

          if system_instruction
            body["system_instruction"] = {parts: [{text: system_instruction}]}
          end
          # puts "body = #{body}"
          request.body = body.to_json

          http.request(request) do |res|
            res.read_body do |chunk|
              yield LlmResponse.new(json_response: JSON.parse(chunk))
            end
          end
        end


        private
        def tools_as_json(tools:)
          {
            functionDeclarations: tools.map(&:to_h)
          }
        end

      end
    end
  end
end