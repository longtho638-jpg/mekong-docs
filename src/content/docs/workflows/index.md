---
title: "Workflows"
description: "Task-oriented guides for common development scenarios with AgencyOS"
section: workflows
order: 0
published: true
---

# Workflows

Task-oriented guides for common development scenarios using AgencyOS's slash commands and agents.

## 🚀 Vibe Coding with Antigravity

For Antigravity IDE users, all workflows integrate with AgencyOS hooks:

```tsx
import { useAgentOS, useTaskTracker, useApprovalGate } from '@/agencyos';

// All workflows use these patterns:
// 1. useAgentOS() - Connect to agents
// 2. useTaskTracker() - Track workflow progress
// 3. useApprovalGate() - Approve critical steps
```

**Quick Commands:**
- `/@planner` → Create plans
- `/@fullstack` → Implement code
- `/@debugger` → Fix bugs
- `/@git-manager` → Commit changes

## Popular Workflows

### Feature Development
[**Feature Development Guide**](/docs/workflows/feature-development) - Complete feature lifecycle from planning to deployment
```bash
/plan "add user authentication with OAuth"
/code @plans/user-auth.md
/fix:test
/git:pr "feature/user-auth"
```

### Bug Fixing
[**Bug Fixing Workflow**](/docs/workflows/bug-fixing) - Systematic approach to debugging and fixing issues
```bash
/debug "login button not working"
/fix:hard
/fix:test
/git:cm
```

### Documentation
[**Documentation Workflow**](/docs/workflows/documentation) - Keep docs in sync with code changes
```bash
/docs:init
/docs:update "after feature changes"
```

## Quick Workflows

### Setup New Project
```bash
python main.py init my-project --kit engineer
cd my-project
/plan "set up project structure"
/code @plans/project-setup.md
```

### Add New Feature
```bash
/plan "add [feature description]"
/code @plans/your-feature.md
/design:good "UI mockups if needed"
/fix:test
/git:cm
```

### Deploy to Production
```bash
/plan "prepare for production deployment"
/fix:ci "fix any failing tests"
/git:pr "deploy-to-production"
```

### Code Review
```bash
/code-review "review recent changes"
/fix "implement suggested improvements"
/git:cm
```

## By Use Case

### Frontend Development
- [UI/UX Design](/docs/commands#design-commands) - `/design:good`, `/design:fast`
- Component Development - `/plan → /code → /fix:test`
- Styling - `/design:good` for aesthetic components

### Backend Development
- API Development - `/plan → /code → /fix:hard`
- Database Changes - `/plan "add user table" → /code`
- Performance Optimization - `/debug "slow queries" → /fix`

### Full Stack
- Complete Features - See [Feature Development](/docs/workflows/feature-development)
- Authentication - `/cook "add authentication with Better Auth"`
- E-commerce - `/cook "add Stripe payment integration`

### DevOps & Infrastructure
- Docker Setup - `/cook "add Docker configuration"`
- CI/CD - `/fix:ci "fix failing GitHub Actions"`
- Deployment - `/plan "deploy to Cloudflare Workers"`

## Advanced Workflows

### Multi-agent Collaboration
```bash
/plan "complex feature with multiple components"
# Spawns: planner → researcher → frontend dev → backend dev → tester

/fix:hard "production bug"
# Spawns: debugger → researcher → dev → tester → reviewer
```

### Content Creation
```bash
/content:good "write marketing copy for new feature"
/content:enhance "improve existing landing page"
/design:good "create visual assets for social media"
```

### Integration Workflows
```bash
/integrate:polar "add Polar billing integration"
/integrate:sepay "add SePay payment gateway"
```

## Getting Started

New to AgencyOS? Start with:
1. [Getting Started Guide](/docs/getting-started) - Learn the basics
2. [Quick Start](/docs/getting-started/quick-start) - Build your first feature
3. [Feature Development](/docs/workflows/feature-development) - Complete workflow example

## Reference

- [Commands Reference](/docs/commands) - All available commands
- [Agents Overview](/docs/agents) - Meet your AI team
- [Skills Library](/docs/skills) - Built-in knowledge modules

## Need Help?

- [Troubleshooting](/docs/support/troubleshooting) - Common issues
- [FAQ](/docs/support/faq) - Frequently asked questions
- [Support](/docs/support) - Get help from the community

---

## 🏯 Binh Pháp Alignment

> **計篇** (Kế) - Strategic calculations

### Zero-Effort Commands

Thay vì làm từng bước, dùng commands tự động:

| Gõ lệnh | Agent tự động làm |
|---------|-------------------|
| `/plan` | Tự tạo implementation plan |
| `/code` | Tự implement theo plan |
| `/ship` | Tự test, review, deploy |

### Related Sync Commands

```bash
# Sync patterns từ Antigravity
/sync-all
```

📖 [Xem tất cả Sync Commands](/docs/commands/sync-commands)
