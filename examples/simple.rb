# Shows a minimal agent

require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/agents/loop_agent"
require_relative "../lib/adk/ruby/models/gemini"
require_relative "../lib/adk/ruby/tools/tool"
require_relative "../lib/adk/ruby/sessions/session"

include Adk::Ruby

gemini = Models::Gemini.new(name: "gemini-2.5-flash")

buffett = Agents::Agent.new(
  name: "buffett",
  description: "A stock market investor agent that thinks like Warren Buffett",
  model: gemini,
  system_instruction: "You are Warren Buffett.
  Answer the questions as Warren Buffett would. Keep the answers short, no longer than 3 lines of text.",
)

Runner.run(agent: buffett)