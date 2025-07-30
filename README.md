# Adk::Ruby

A proof-of-concept Ruby implementation of Agent Development Kit, inspired by Google's Python ADK.

See the [examples folder](./examples/) for how to use this.

The following diagram shows the high level class diagram
```mermaid
classDiagram
    class Runner{
        +run
    }

    class Agent{
        +string run_prompt(prompt:)
    }

    class Tool{
        +lambda callable
    }

    Agent <|-- LoopAgent: Is a

    class Session{
        +Hash outputs
    }

    Model <|-- Gemini: Is a

    Runner --> Agent: starts
    Agent *-- Agent: sub_agents
    Agent --> Session: singleton
    Agent --> Model: uses
    Agent --> Tool: uses
```