---
title: "Supervisor Pattern Workflow"
description: "Multi-agent coordination with VoltAgent supervisor pattern"
section: "workflows"
order: 16
published: true
---

# 🤖 Supervisor Pattern Workflow

> **WIN-WIN-WIN**: Client WIN (efficiency) → Agency WIN (scale) → Owner WIN (leverage)

---

## Overview

Coordinate multiple AI agents using the VoltAgent supervisor pattern.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│              SUPERVISOR AGENT                   │
│         (orchestration & routing)               │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│  │ Scout   │  │ Editor  │  │ Director│         │
│  │ Agent   │  │ Agent   │  │ Agent   │         │
│  └─────────┘  └─────────┘  └─────────┘         │
│                                                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│  │Community│  │Research │  │ Analyst │         │
│  │ Agent   │  │ Agent   │  │ Agent   │         │
│  └─────────┘  └─────────┘  └─────────┘         │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## VoltAgent Implementation

```typescript
import { VoltAgent, Agent } from "@voltagent/core";

// Supervisor coordinates sub-agents
const supervisor = new Agent({
  name: "supervisor",
  instructions: "Route tasks to specialized agents",
  subAgents: [scoutAgent, editorAgent, directorAgent],
});

new VoltAgent({
  agents: { supervisor },
  workflows: { contentPipeline },
});
```

---

## AgencyOS Hub Mapping

| VoltAgent | AgencyOS Hub |
|-----------|--------------|
| Scout | `binh-phap-hub` |
| Editor | `content-hub` |
| Director | `creative-hub` |
| Community | `community-hub` |
| Research | `vc-hub` |
| Analyst | `finance-hub` |

---

## Use Cases

1. **Content Pipeline**: Scout → Editor → Director → Community
2. **Client Onboarding**: CSM → Tech → Success
3. **Fundraising**: Research → Pitch → IR

---

## Binh Pháp Alignment

> **Chapter 9: Hành Quân** - Coordinated execution

- Clear command hierarchy
- Specialized agents
- Unified strategy

---

**🏯 "Họ WIN → Mình WIN"**
