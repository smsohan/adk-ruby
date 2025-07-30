require_relative "ruby/version"
require_relative "ruby/sessions/session"

module Adk
  module Ruby
    class Runner
      def self.run(agent:)

        puts "*" * 30
        puts "Running the following agent hierarchy"
        puts agent.tree
        puts "*" * 30

        trap("SIGINT") { exit }
        while true
          print "[prompt] "

          prompt = gets.chomp
          break if prompt == "exit"

          agent.handle_prompt(prompt: prompt) unless prompt.empty?
        end

        puts "\n\n" + '*' * 30 +  " Session Summary " + '*' * 30 + "\n\n"

        puts Sessions::Session.instance.contents

        puts "\n\n" + '*' * 30 +  " bye bye! " + '*' * 30
      end
    end
  end
end
