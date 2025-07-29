require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/agents/loop_agent"
require_relative "../lib/adk/ruby/models/gemini"
require_relative "../lib/adk/ruby/tools/tool"
require_relative "../lib/adk/ruby/sessions/session"

include Adk::Ruby

math_tool = Tools::Tool.new(
  name: "math_tool",
  description: "A tool that can handle math problems",
  parameters: {
    type: "object",
    properties: {
      expression: {
        type: "string",
        description: "The math problem to solve, expressions must match that of Ruby"
      },
    },
    required: ["expression"],
  },
  response: {
    type: "number",
    description: "The result of the math problem"
  },
  callable: ->(expression:) {
    unless expression.match?(/^[\d\s\+\-\*\/\(\).]+$/)
      raise ArgumentError, "Invalid characters in expression"
    end
    eval(expression)
  }
)


weather_tool = Tools::Tool.new(
  name: "weather_tool",
  description: "A tool can answer weather related queries",
  parameters: {
    type: "object",
    properties: {
      location: {
        type: "string",
        description: "The location of the place for the weather"
      },
    },
    required: ["location"],
  },
  response: {
    type: "string",
    description: "a human readable weather description"
  },
  callable: ->(location:) {
    ["Oh so Sunny!", "Damn, it's Cloudy :-(", "Romantic Rainy today", "Festive Snowy!"].sample
  }
)

gemini = Models::Gemini.new(name: "gemini-2.5-flash",
  project_id: "sohansm-project",
  location: "us-central1"
)

math_agent = Agents::Agent.new(
  name: "math_agent",
  description: "An agent that can solve math problems",
  model: gemini,
  tools: [math_tool]
)

weather_agent = Agents::Agent.new(
  name: "weather_agent",
  description: "An agent that can answer weather related queries",
  model: gemini,
  tools: [weather_tool]
)

root_agent = Agents::Agent.new(
  name: "root_agent",
  description: "The root agent",
  sub_agents: [math_agent, weather_agent],
  model: gemini
)

# Runner.run(agent: root_agent)

buffet = Agents::Agent.new(
  name: "buffet",
  description: "An stock market investor agent that thinks like Warren Buffet",
  model: gemini,
  system_instruction: "You are Warren Buffet. Answer the questions as Warren Buffet would. Keep the answers short, no longer than 3 lines of text.",
  output_key: "buffet_answer"
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
  sub_agents: [buffet, ives],
  model: gemini
)

sentiment_agent = Agents::Agent.new(
  name: "sentiment_agent",
  description: "The investor sentiment agent",
  model: gemini,
  system_instruction: "You are making an investment decision research. Compare the sentiment from {buffet_answer} and {ives_answer} and label it using (positive, neutral, negative)"
)

root_agent =  Agents::LoopAgent.new(
  name: "root_agent",
  description: "The root investor agent",
  sub_agents: [investor_agent, sentiment_agent],
  model: gemini
)

Runner.run(agent: root_agent)