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
  callable: ->(expression:) {
    eval(expression)
  }
)

agent = Agents::Agent.new(
  name: "Gemini",
  description: "A simple model that uses Gemini",
  model: Models::Gemini.new(name: "gemini-2.5-flash",
    project_id: "sohansm-project",
    location: "us-central1"
  ),
  tools: [math_tool]
)
Runner.run(agent: agent)