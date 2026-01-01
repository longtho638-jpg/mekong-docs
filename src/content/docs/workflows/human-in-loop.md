---
title: "Human-in-Loop Workflow"
description: "Approval workflows with suspend/resume capability"
section: "workflows"
order: 18
published: true
---

# 👤 Human-in-Loop Workflow

> **WIN-WIN-WIN**: Client WIN (control) → Agency WIN (trust) → Owner WIN (quality)

---

## Overview

Build approval workflows that pause for human decision-making.

---

## Suspend/Resume Pattern

```typescript
import { createWorkflowChain } from "@voltagent/core";

export const proposalApprovalWorkflow = createWorkflowChain({
  id: "proposal-approval",
  name: "Proposal Approval",
  purpose: "Get manager approval for large proposals",
})
.andThen({
  id: "check-approval-needed",
  resumeSchema: z.object({
    approved: z.boolean(),
    comments: z.string().optional(),
  }),
  execute: async ({ data, suspend, resumeData }) => {
    // If resuming with decision
    if (resumeData) {
      return { ...data, approved: resumeData.approved };
    }
    
    // Proposals over $10K need approval
    if (data.amount > 10000) {
      await suspend("Manager approval required", {
        proposalId: data.id,
        amount: data.amount,
      });
    }
    
    // Auto-approve smaller proposals
    return { ...data, approved: true };
  },
});
```

---

## Approval Types

| Type | Threshold | Approver |
|------|-----------|----------|
| Proposal | > $10K | Manager |
| Contract | All | Legal |
| Expense | > $500 | Finance |
| Content | Sensitive | Editor |

---

## Workflow States

```
┌─────────────────────────────────────────────────┐
│  RUNNING → SUSPENDED → RESUMED → COMPLETED     │
│     │                      │                    │
│     └──────────────────────┘                    │
│            (auto-approve)                       │
└─────────────────────────────────────────────────┘
```

---

## AgencyOS Modules

| Module | Purpose |
|--------|---------|
| `notifications.py` | Approval notifications |
| `scheduler.py` | Deadline tracking |
| `meeting.py` | Approval meetings |

---

## Binh Pháp Alignment

> **Chapter 8: Cửu Biến** - Flexibility

- Not everything should be automated
- Critical decisions need humans
- Balance speed with quality

---

**🏯 "Họ WIN → Mình WIN"**
