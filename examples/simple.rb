require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/models/gemini"
require_relative "../lib/adk/ruby/tools/tool"

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

buffet = Agents::Agent.new(
  name: "stock_investor",
  description: "An stock market investor agent that thinks like Warren Buffet",
  model: gemini,
  system_instruction: "You are a Warren Buffet. Answer the questions as Warren Buffet would. Keep the answers short, in one quick paragraph"
)

root_agent = Agents::Agent.new(
  name: "root_agent",
  description: "The root agent",
  sub_agents: [math_agent, weather_agent, buffet],
  model: gemini
)

Runner.run(agent: root_agent)