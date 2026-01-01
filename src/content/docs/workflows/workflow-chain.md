---
title: "Workflow Chain Workflow"
description: "VoltAgent workflow chain pattern for automation"
section: "workflows"
order: 17
published: true
---

# ⛓️ Workflow Chain Workflow

> **WIN-WIN-WIN**: Client WIN (automation) → Agency WIN (efficiency) → Owner WIN (margins)

---

## Overview

Create multi-step automated workflows using VoltAgent's workflow chain pattern.

---

## Chain Pattern

```typescript
import { createWorkflowChain } from "@voltagent/core";
import { z } from "zod";

export const clientOnboardingChain = createWorkflowChain({
  id: "client-onboarding",
  name: "Client Onboarding Workflow",
  purpose: "Automate new client setup",
  input: z.object({
    clientId: z.string(),
    tier: z.enum(["warrior", "general", "tuong-quan"]),
  }),
  result: z.object({
    status: z.enum(["completed", "failed"]),
    portalUrl: z.string(),
  }),
})
.andThen({
  id: "create-workspace",
  execute: async ({ data }) => {
    // Create client workspace
    return { ...data, workspaceId: "ws-123" };
  },
})
.andThen({
  id: "provision-access",
  execute: async ({ data }) => {
    // Grant portal access
    return { ...data, portalUrl: "https://portal.agencyos.network" };
  },
})
.andThen({
  id: "send-welcome",
  execute: async ({ data }) => {
    // Send welcome email
    return { status: "completed", portalUrl: data.portalUrl };
  },
});
```

---

## Common Chains

| Chain | Steps | Trigger |
|-------|-------|---------|
| Client Onboarding | 5 | New client |
| Invoice Processing | 3 | Monthly |
| Content Pipeline | 4 | Weekly |
| Report Generation | 6 | Monthly |

---

## AgencyOS Modules

| Module | Purpose |
|--------|---------|
| `automation.py` | Process automation |
| `data_automation.py` | Data workflows |
| `email_automation.py` | Email sequences |

---

## Binh Pháp Alignment

> **Chapter 7: Quân Tranh** - Speed & efficiency

- Automate repetitive tasks
- Reduce human error
- Scale without hiring

---

**🏯 "Họ WIN → Mình WIN"**
