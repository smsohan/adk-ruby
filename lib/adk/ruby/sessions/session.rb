module Adk
  module Ruby
    module Sessions
      class Session

        attr_accessor :contents
        def initialize(contents:)
          @contents = contents
        end

        def last_user_prompt
          # puts "contents= #{@contents}"
          @contents.reverse.find{|content|content[:role] == 'user'}[:parts][0][:text]
        end

      end
    end
  end
end