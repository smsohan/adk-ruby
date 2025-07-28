require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/models/gemini"

include Adk::Ruby

agent = Agents::Agent.new(
  name: "Gemini",
  description: "A simple model that uses Gemini",
  model: Models::Gemini.new(name: "gemini-2.5-flash",
    project_id: "sohansm-project",
    location: "us-central1"
  )
)
Runner.run(agent: agent)