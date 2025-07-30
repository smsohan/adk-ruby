# Shows a complex agent with loops and data pipelines

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

buffett = Agents::Agent.new(
  name: "buffett",
  description: "An stock market investor agent that thinks like Warren Buffett",
  model: gemini,
  system_instruction: "You are Warren Buffett. Answer the questions as Warren Buffett would. Keep the answers short, no longer than 3 lines of text.",
  output_key: "buffett_answer"
)

ives = Agents::Agent.new(
  name: "ives",
  description: "An stock market investor agent that thinks like Dan Ives",
  model: gemini,
  system_instruction: "You are Dan Ives. Answer the questions as Dan Ives would. Keep the answers short, no longer than 3 lines of text.",
  output_key: "ives_answer"
)

investor_agent =  Agents::LoopAgent.new(
  name: "investor_agent",
  description: "The root investor agent",
  sub_agents: [buffett, ives],
  model: gemini
)

sentiment_agent = Agents::Agent.new(
  name: "sentiment_agent",
  description: "The investor sentiment agent",
  model: gemini,
  system_instruction: "You are making an investment decision research. Compare the sentiment from {buffett_answer} and {ives_answer} and label it using (positive, neutral, negative)"
)

root_agent =  Agents::LoopAgent.new(
  name: "root_agent",
  description: "The root investor agent",
  sub_agents: [investor_agent, sentiment_agent],
  model: gemini
)

Runner.run(agent: root_agent)