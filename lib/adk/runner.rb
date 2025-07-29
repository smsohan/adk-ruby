require_relative "ruby/version"

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
          puts "[User]"
          agent.handle_prompt(prompt: gets)
        end

      end
    end
  end
end
