---
title: "AgencyOS Agents"
description: "17 specialized AI agents powering AgencyOS"
section: "docs"
category: "reference"
order: 2
---

# AgencyOS Agents

> 17 specialized AI agents that power every command

## 🤖 Core Agents

| Agent | Role | Used By |
|-------|------|---------|
| `planner` | Creates implementation plans | `/plan`, `/binh-phap` |
| `researcher` | Gathers information & context | `/intel`, `/scout` |
| `copywriter` | Generates marketing copy | `/marketing/*`, `/video/*` |
| `scout` | Finds opportunities | `/affiliate/*`, `/sales/lead` |
| `fullstack-developer` | Implements features | `/code`, `/fix` |
| `tester` | Runs & validates tests | `/test` |
| `debugger` | Diagnoses issues | `/debug`, `/fix` |
| `code-reviewer` | Reviews code quality | `/review` |
| `docs-manager` | Manages documentation | `/docs/*` |
| `project-manager` | Coordinates tasks | `/sprint`, `/okr` |
| `architect` | Designs systems | `/design`, `/plan` |
| `security-expert` | Security audits | `/audit` |
| `ux-designer` | UI/UX improvements | `/design/ui` |
| `performance-expert` | Optimization | `/optimize` |
| `data-engineer` | Data pipelines | `/data` |
| `devops` | Deployment & CI/CD | `/ship` |
| `scout-external` | External API research | `/intel/vc` |

## 🔄 Agent Orchestration

Agents work together in workflows:

```
/sales/proposal →
  1. scout: Find client info
  2. researcher: Analyze needs
  3. copywriter: Write proposal
  4. planner: Create timeline
```

## 💡 How Agents Are Selected

Each command specifies which agents to use:

```markdown
# /marketing/social

Spawn agents: `copywriter` + `scout`
```

---

*AgencyOS v10.0 | 17 Agents | Multi-Agent Orchestration*
