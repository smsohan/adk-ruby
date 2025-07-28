require_relative "ruby/version"

module Adk
  module Ruby
    class Runner
      def self.run(agent:)
        trap("SIGINT") { exit }
        agent.run
      end
    end
  end
end
