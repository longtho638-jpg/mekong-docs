---
title: "Sales Pipeline Workflow"
description: "Lead to client conversion workflow for AgencyOS"
section: "workflows"
order: 1
published: true
---

# 🎯 Sales Pipeline Workflow

> **WIN-WIN-WIN**: Lead WIN (value) → Agency WIN (client) → Owner WIN (revenue)

---

## Overview

Convert leads into paying clients using AgencyOS CRM and sales automation.

**Target Path**: Bootstrap (70%) and VC-Ready (30%)

---

## Pipeline Stages

```
┌─────────────────────────────────────────────────┐
│  Stage 1: LEAD                                  │
│  ├── Source: Inbound, Outbound, Referral       │
│  └── Action: Qualify with lead_scoring.py      │
├─────────────────────────────────────────────────┤
│  Stage 2: QUALIFIED                            │
│  ├── Score: 60+ points                         │
│  └── Action: Discovery call                    │
├─────────────────────────────────────────────────┤
│  Stage 3: PROPOSAL                             │
│  ├── Tool: proposal_generator.py               │
│  └── Action: Send within 24 hours              │
├─────────────────────────────────────────────────┤
│  Stage 4: NEGOTIATION                          │
│  ├── Handle objections                         │
│  └── Adjust pricing if needed                  │
├─────────────────────────────────────────────────┤
│  Stage 5: CLOSED-WON                           │
│  ├── Contract signed                           │
│  └── Trigger: client-onboarding.md             │
└─────────────────────────────────────────────────┘
```

---

## AgencyOS Modules

| Module | Purpose |
|--------|---------|
| `crm.py` | Contact & deal management |
| `lead_scoring.py` | Qualification scoring |
| `proposal_generator.py` | Proposal creation |
| `contract_manager.py` | Contract handling |

---

## Lead Scoring Criteria

| Factor | Points |
|--------|--------|
| Budget confirmed | +20 |
| Decision maker | +15 |
| Timeline < 30 days | +15 |
| Referral source | +20 |
| Industry match | +10 |
| Team size 5+ | +10 |
| Previous agency experience | +10 |
| **Qualified threshold** | **60+** |

---

## Binh Pháp Alignment

> **Chapter 3: Mưu Công** - Win without fighting

- Qualify hard, close easy
- No bad-fit clients
- Referrals over cold outreach

---

## Quick Commands

```bash
# View pipeline
mekong crm pipeline

# Score a lead
mekong lead-score --company "ABC Corp"

# Generate proposal
mekong proposal --client "ABC Corp" --tier "warrior"
```

---

**🏯 "Họ WIN → Mình WIN"**
