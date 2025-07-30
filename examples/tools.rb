# Shows a single agent with tools

require_relative "../lib/adk/runner"
require_relative "../lib/adk/ruby/agents/agent"
require_relative "../lib/adk/ruby/agents/loop_agent"
require_relative "../lib/adk/ruby/models/gemini"
require_relative "../lib/adk/ruby/tools/tool"
require_relative "../lib/adk/ruby/sessions/session"

include Adk::Ruby

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

gemini = Models::Gemini.new(name: "gemini-2.5-flash")

weather_agent = Agents::Agent.new(
  name: "weather_agent",
  description: "An agent that can answer weather related queries",
  model: gemini,
  tools: [weather_tool]
)

Runner.run(agent: weather_agent)