---
title: "Upgrade Guide for Mekong CLI Users"
description: "Migrate from Mekong CLI to AgencyOS seamlessly"
section: getting-started
order: 3
published: true
---

# Upgrading from Mekong CLI to AgencyOS

Already using Mekong CLI? AgencyOS enhances your workflow without breaking existing habits.

## What Changes?

**Stays the Same**:
- Mekong CLI CLI and interface
- Existing project structure
- .claude/ directory (extended, not replaced)
- Chat-based interaction

**New Capabilities**:
- Slash commands for common tasks
- Specialized agents (planner, tester, debugger)
- Reusable skills library
- Multi-agent collaboration

## Installation (Additive)

```bash
# Install AgencyOS CLI (doesn't replace Mekong CLI)
npm install -g mekong-cli

# Initialize in existing project
mk init
# → Adds .claude/CLAUDE.md, skills/, workflows/
# → Existing .claude/commands/ preserved
```

### Upgrading AgencyOS

```bash
# Recommended: Use built-in update command
mk update

# Alternative: npm global update
npm install -g mekong-cli@latest
```

## Gradual Migration Path

### Week 1: Try Core Commands
Start with `/cook` for feature development:
```bash
# Old way
You: "I need to add a new API endpoint for user profiles"
[Long conversation with manual guidance]

# AgencyOS way
/cook "add user profiles API endpoint"
[Automated planning, development, testing]
```

### Week 2: Use Specialized Workflows
Adopt task-specific commands:
- `/fix` for bug fixing (faster than manual debugging)
- `/plan` for complex features (structured planning)
- `/docs:update` for documentation (automated sync)

### Week 3: Leverage Skills
Add custom skills for your stack:
```bash
/skill:create "Our GraphQL conventions"
# → Agents learn your team's patterns
```

### Week 4: Full Workflow Integration
Combine commands for complete workflows:
```bash
/plan "redesign checkout flow"
/code @plans/checkout-redesign.md
/design:good "checkout UI mockup"
/fix:test
/git:pr "feature/new-checkout"
```

## Compatibility

**Supported**:
- Mekong CLI v1.0+
- Existing .claude/commands/ (fully compatible)
- Custom prompts (still work as-is)

**Not Supported**:
- Claude Desktop app (Mekong CLI CLI only)
- Projects without Git (AgencyOS requires version control)

## FAQs

**Q: Do I need to rewrite existing commands?**
A: No. AgencyOS commands coexist with your custom .claude/commands/

**Q: Can I still use regular chat?**
A: Yes. AgencyOS adds slash commands, doesn't remove chat.

**Q: What if I don't like AgencyOS?**
A: Uninstall and delete .claude/CLAUDE.md. No breaking changes.

## Next Steps

1. [Install AgencyOS](/docs/getting-started/installation)
2. [Try Quick Start](/docs/getting-started/quick-start)
3. [Explore Commands](/docs/commands)