require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/agents/loop_agent"
require_relative "../lib/adk/ruby/models/gemini"
require_relative "../lib/adk/ruby/tools/tool"
require_relative "../lib/adk/ruby/sessions/session"

include Adk::Ruby

gemini = Models::Gemini.new(name: "gemini-2.5-flash",
  project_id: "sohansm-project",
  location: "us-central1"
)

buffet = Agents::Agent.new(
  name: "buffet",
  description: "An stock market investor agent that thinks like Warren Buffet",
  model: gemini,
  system_instruction: "You are Warren Buffet.
  Answer the questions as Warren Buffet would. Keep the answers short, no longer than 3 lines of text.",
  output_key: "buffet_answer"
)

Runner.run(agent: buffet)