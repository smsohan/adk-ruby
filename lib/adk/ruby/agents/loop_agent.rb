require_relative './agent'

module Adk
  module Ruby
    module Agents
      class LoopAgent < Agent

        def handle_prompt(prompt:)
          @sub_agents.each do |agent|
            agent.handle_prompt(prompt: prompt)
          end
        end

      end
    end
  end
end
