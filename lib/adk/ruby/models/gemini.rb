require 'logger'
require 'net/http'
require 'json'

module Adk
  module Ruby
    module Models
      class Gemini

        attr_accessor :name
        def initialize(name:, project_id:, location:)
          @name = name
          @project_id = project_id
          @location = location
        end

        def generate_content(prompt:)
          url = "https://generativelanguage.googleapis.com/v1beta/models/#{@name}:generateContent?key=#{ENV['GEMINI_API_KEY']}"
          uri = URI(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.path + "?" + uri.query)
          request['Content-Type'] = 'application/json'
          request.body = {
            contents: [
              {
                parts: [
                  { text: prompt }
                ]
              }
            ]
          }.to_json

          http.request(request) do |res|
            res.read_body do |chunk|
              puts JSON.parse(chunk)["candidates"][0]["content"]["parts"][0]["text"]
            end
          end
        end

      end
    end
  end
end