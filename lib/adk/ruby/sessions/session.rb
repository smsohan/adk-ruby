module Adk
  module Ruby
    module Sessions
      class Session

        attr_accessor :contents, :outputs

        def last_user_prompt
          @contents.reverse.find{|content|content[:role] == 'user'}[:parts][0][:text]
        end

        def self.instance
          @instance ||= new
        end

        private
        def initialize(contents: [])
          @contents = contents
          @outputs = {}
        end

      end
    end
  end
end