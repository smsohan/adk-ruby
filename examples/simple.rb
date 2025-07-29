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
        description: "The math problem to solve"
      },
    },
    required: ["expression"],
  },
  response: {
    type: "number",
    description: "The result of the math problem"
  },
  callable: ->(expression:) {
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


agent = Agents::Agent.new(
  name: "Gemini",
  description: "A simple model that uses Gemini",
  model: Models::Gemini.new(name: "gemini-2.5-flash",
    project_id: "sohansm-project",
    location: "us-central1"
  ),
  tools: [math_tool, weather_tool]
)
Runner.run(agent: agent)