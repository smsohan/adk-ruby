# Shows two agents with their own tools being used together

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

Runner.run(agent: root_agent)