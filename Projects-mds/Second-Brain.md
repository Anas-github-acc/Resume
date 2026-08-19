# Projects Details

## Second Brain

### What problem does it solve?

Second Brain is an **agentic career decision-intelligence system** for making career choices under uncertainty. Instead of giving a single AI-generated recommendation, it models the user's context, goals, constraints, available evidence, trade-offs, dependencies, and possible future scenarios as an interactive decision graph.

The goal is to turn an ambiguous natural-language career question into a structured, evidence-backed decision process that the user can inspect and explore through "what-if" scenarios.

---

## Architecture

```text
                              SECOND BRAIN
                       Agentic Decision System

                                  User
                                   |
                                   v
                      +-------------------------+
                      |   Context Extraction    |
                      | goals / constraints /   |
                      | missing information     |
                      +------------+------------+
                                   |
                                   v
                      +-------------------------+
                      |      Context Agent      |
                      |  Structured User State  |
                      +------------+------------+
                                   |
                                   v
                      +-------------------------+
                      |   Workflow Orchestration|
                      | agent + pipeline routing|
                      +------------+------------+
                                   |
                    +--------------+---------------+
                    |                              |
                    v                              v
          +--------------------+         +----------------------+
          |   Research Agent   |         | Persistent / Cached  |
          | query decomposition|         | State                |
          +---------+----------+         | Redis / PostgreSQL   |
                    |                    +----------------------+
                    v
          +---------------------------------------+
          |            Hybrid RAG Toolchain       |
          |                                       |
          | Query Rewriting                       |
          |        |                              |
          | Semantic Retrieval                    |
          |        |                              |
          | Re-ranking                            |
          |        |                              |
          | Evidence Extraction                   |
          +-------------------+-------------------+
                              |
                              v
                    Evidence + User Context
                              |
                              v
          +---------------------------------------+
          |       Multi-Stage LLM Reasoning       |
          |          GPT-OSS-120B                 |
          |                                       |
          | Alternatives -> Trade-offs            |
          | Dependencies -> Future Scenarios      |
          +-------------------+-------------------+
                              |
                              v
          +---------------------------------------+
          |        Graph Intelligence Layer       |
          |        Validation / Guardrails        |
          |                                       |
          | - Contradiction detection             |
          | - Invalid transition detection        |
          | - Dead-end detection                  |
          +-------------------+-------------------+
                              |
                              v
                       Valid Decision Graph
                              |
                    +---------+----------+
                    |                    |
                    v                    v
          +-------------------+    +----------------------+
          |  Scenario Agent   |    | React Flow Renderer  |
          | what-if reasoning |    | Interactive Graph    |
          +---------+---------+    +----------------------+
                    |
                    v
             Modify assumptions
                    |
                    v
          Recompute affected branches
```

---

## How it works

Second Brain uses a **multi-agent orchestration pipeline** that separates context understanding, evidence gathering, reasoning, validation, and interactive scenario exploration into specialized components.

### 1. Context Extraction and Context Agent

A lightweight LLM pipeline first converts the user's vague career question into structured information including:

- goals,
- constraints,
- current situation,
- assumptions,
- and missing information.

The **Context Agent** maintains this structured user state so downstream agents operate on the same decision context instead of independently interpreting the raw user prompt.

### 2. Research Agent and RAG Toolchain

The **Research Agent** decomposes the decision problem into smaller research queries and runs them through a hybrid RAG pipeline.

The retrieval toolchain consists of:

1. **Query rewriting** to transform the decision problem into retrieval-oriented queries.
2. **Semantic retrieval** to identify relevant career and market information.
3. **Re-ranking** to prioritize the most useful retrieved evidence.
4. **Evidence extraction** to provide focused information to the reasoning pipeline.

This layer grounds downstream reasoning in retrieved evidence instead of relying only on the model's internal knowledge.

### 3. Multi-Stage Reasoning Pipeline

The structured user context and retrieved evidence are passed into a multi-stage reasoning pipeline using the **GPT-OSS-120B model through OpenRouter**.

Rather than producing one direct recommendation, the pipeline decomposes the problem into:

- possible alternatives,
- trade-offs,
- dependencies,
- risks,
- constraints,
- and potential future scenarios.

The output is a structured decision graph rather than plain natural-language advice.

### 4. Graph Intelligence Guardrail Layer

Before the graph is exposed to the user, it passes through a **Graph Intelligence validation layer**.

This layer acts as a guardrail around generated reasoning by checking the graph for:

- contradictory paths,
- invalid state or decision transitions,
- and dead-end branches.

Only after validation is the decision structure compiled into an interactive **React Flow** graph.

This validation boundary separates LLM generation from the final user-facing representation and makes the agentic workflow more reliable and testable.

### 5. Scenario Agent

The **Scenario Agent** powers interactive "what-if" exploration.

When the user changes an assumption or constraint, the Scenario Agent determines which portions of the decision graph are affected and recomputes those branches instead of regenerating the entire decision structure.

This allows the user to compare outcomes as assumptions change while preserving unaffected parts of the graph.

---

## Agent Responsibilities

| Agent / Layer | Responsibility |
|---|---|
| **Context Agent** | Maintains structured user goals, constraints, assumptions, and missing information |
| **Research Agent** | Decomposes the decision into research queries and invokes the RAG retrieval pipeline |
| **Reasoning Pipeline** | Converts context + evidence into alternatives, trade-offs, dependencies, and scenarios |
| **Graph Intelligence** | Validates generated decision graphs and blocks contradictions, invalid transitions, and dead ends |
| **Scenario Agent** | Handles what-if changes and recomputes only affected graph branches |

---

## Orchestration and Tooling

The system is designed as a staged agent workflow rather than a single LLM call:

```text
User Input
   |
   v
Context Extraction
   |
   v
Context Agent
   |
   v
Research Agent
   |
   v
RAG Toolchain
   |
   v
Multi-Stage Reasoning
   |
   v
Graph Intelligence Guardrails
   |
   v
Scenario Agent / React Flow
```

The supporting tooling includes:

- structured context/state management,
- query decomposition,
- query rewriting,
- semantic retrieval,
- re-ranking,
- evidence extraction,
- structured graph generation,
- graph validation,
- persistent/cached state with Redis and PostgreSQL,
- and interactive graph rendering with React Flow.

---

## Reliability and Guardrails

Second Brain does not directly expose raw LLM reasoning output as the final result.

The **Graph Intelligence layer** creates a validation boundary between generation and presentation. It checks structural properties of the generated graph before it reaches the user.

Current validation focuses on:

- contradiction detection,
- invalid transition detection,
- dead-end detection,
- and structural graph validity before React Flow rendering.

This design treats validation as part of the agent harness rather than relying only on prompt instructions.

---

## Evaluation Harness — Architecture Extension

> **Status:** Architecture extension / next implementation step. Do not present this section as already implemented until the evaluation harness is built.

The architecture can be extended with an automated evaluation harness that runs a fixed regression dataset of career-decision prompts through the same agent pipeline.

```text
                           Agent Workflow
                                |
                 +--------------+--------------+
                 |                             |
                 v                             v
          Production Run                Evaluation Harness
                 |                             |
                 v                             v
        Generated Decision Graph       Regression Test Cases
                                               |
                         +---------------------+--------------------+
                         |                     |                    |
                         v                     v                    v
                  Graph Validity       Evidence Grounding    Scenario Consistency
                         |                     |                    |
                         +---------------------+--------------------+
                                               |
                                               v
                                         Evaluation Report
```

The evaluation harness should test:

- **graph validity** — generated output follows the expected graph structure,
- **contradiction rate** — conflicting branches or claims are detected,
- **transition validity** — graph edges represent valid decision transitions,
- **dead-end detection** — incomplete reasoning paths are surfaced,
- **evidence grounding** — reasoning stages are supported by retrieved evidence where required,
- **scenario consistency** — what-if changes update affected branches without corrupting unrelated branches,
- **structured-output validity** — generated graph data conforms to the expected schema.

This would provide a repeatable regression layer for testing changes to prompts, retrieval, reasoning stages, and agent behavior.

---

## Core Technical Areas Demonstrated

### AI Agents / Agentic Systems
- Specialized Context, Research, and Scenario agents.
- Role-separated responsibilities across the decision workflow.
- Stateful interaction between context, retrieval, reasoning, and scenario exploration.

### Agent Orchestration
- Multi-stage workflow connecting specialized agents and deterministic processing layers.
- Explicit handoff of structured state and evidence between pipeline stages.
- Selective recomputation during what-if exploration.

### Tooling
- Hybrid RAG pipeline.
- Query rewriting.
- Semantic retrieval.
- Re-ranking.
- Evidence extraction.
- Structured graph generation.
- React Flow visualization.
- Redis and PostgreSQL-backed state.

### Guardrails
- Contradiction detection.
- Invalid transition detection.
- Dead-end detection.
- Validation before graph rendering.

### Evaluation
- Graph Intelligence already provides runtime validation.
- A regression-based evaluation harness is the next architecture extension for systematic agent evaluation and testing.

---

## Resume-Oriented Summary

Second Brain can be described as a **multi-agent decision-intelligence system** that orchestrates Context, Research, and Scenario agents across structured context extraction, hybrid RAG, multi-stage LLM reasoning, graph validation, and dynamic what-if recomputation.

Its **Graph Intelligence layer** acts as a runtime guardrail by validating generated decision graphs for contradictions, invalid transitions, and dead ends before rendering them as interactive React Flow graphs.
