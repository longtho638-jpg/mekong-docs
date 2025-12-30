---
title: Scout Agent
description: Rapidly locate relevant files across large codebases using parallel agentic search with Gemini and OpenCode
section: docs
category: agents
order: 8
published: true
---

# Scout Agent

Parallel AI file search across large codebases—organized results in <5 minutes.

## When to Use

- **Feature work**: Find all files spanning multiple directories before implementation
- **Debugging**: Locate integration points across unfamiliar codebase areas
- **Onboarding**: Map project structure for authentication, payments, or any feature domain
- **Refactoring**: Identify affected files before widespread changes

## Key Capabilities

| Capability | Description |
|------------|-------------|
| **Parallel Search** | Spawns 1-10 agents (Gemini + OpenCode) to search simultaneously |
| **Smart Division** | Splits codebase into logical sections per agent |
| **Organized Output** | Groups results by purpose (Core, API, Tests, Config, Docs) |
| **Timeout Handling** | 3-min limit per agent, uses partial results if needed |
| **Deduplication** | Removes duplicate paths, highlights cross-category files |

## Common Use Cases

**1. Developer starting feature**
```bash
/scout "locate all authentication-related files" 5
```
*Gets organized list: auth services, middleware, routes, tests, config—ready to start.*

**2. DevOps debugging production issue**
```bash
/scout "find Stripe payment webhook and error handling" 4
```
*Finds: payment service, webhook routes, error middleware, logging, integration tests.*

**3. Junior dev onboarding**
```bash
/scout "locate database models and migration files" 3
```
*Maps data layer: models, migrations, seeds, schema validation, ORM config.*

**4. Tech lead planning refactor**
```bash
/scout "find all API rate limiting and middleware" 6
```
*Discovers: rate limit middleware, Redis integration, route guards, tests, docs.*

**5. Consultant auditing codebase**
```bash
/scout "locate security-related files (auth, CORS, validation)" 8
```
*Comprehensive scan: auth guards, input validation, CORS config, security tests.*

## Pro Tips

**Scale Guidelines**:
- **1-3 agents**: Small projects (<100 files) or targeted searches → Gemini only
- **4-6 agents**: Medium projects (100-500 files) → Gemini + OpenCode mix
- **7-10 agents**: Large codebases (500+ files) or monorepos → Full parallelization

**Search Query Tips**:
- ✅ Specific: `"authentication middleware and JWT validation"`
- ❌ Vague: `"auth stuff"`
- Include file types: `"TypeScript service files for payment"`
- Add constraints: `"only in src/api directory"`

**Reading Results**:
- Don't skip "Configuration" or "Tests" sections—critical context
- Files in multiple categories = key integration points
- Review file counts: 50+ files = query too broad, narrow it down

**Performance**:
- Small project (scale=3): 1-2 min, 95% coverage
- Medium (scale=5): 2-4 min, 90% coverage
- Large (scale=8): 3-5 min, 85% coverage
- Monorepo (scale=10): 4-5 min, 75-80% coverage (speed/coverage trade-off)

**Troubleshooting**:
- Too many files (100+): Be more specific or reduce scale
- Missing expected files: Increase scale or check `.gitignore` exclusions
- Agent timeout: Partial results still useful, other agents likely found relevant files

## Related Agents

- [Planner Agent](/docs/agents/planner) - Uses scout results to create implementation plans
- [Debugger Agent](/docs/agents/debugger) - Leverages scout to find debugging targets
- [Fullstack Developer](/docs/agents/fullstack-developer) - Runs scout before full-stack features

## AgencyOS Integration

Track parallel search progress with TaskTracker:

### Hook Setup

```tsx
import { useAgentOS, useTaskTracker, AgentActivityFeed } from '@/agencyos';

function ScoutPanel() {
  const { state } = useAgentOS({ agentName: 'scout' });
  const { progress, initTask, completeStep } = useTaskTracker();

  async function runScout(query: string, agentCount: number) {
    initTask(`Scout: ${query}`, 
      Array.from({ length: agentCount }, (_, i) => `Agent ${i + 1} search`)
    );
    
    // As each parallel agent completes
    completeStep(`step_${agentIndex}`);
  }

  return (
    <AgentActivityFeed
      activities={searchResults.map(r => ({
        agentName: 'scout',
        action: `Found ${r.fileCount} files in ${r.category}`,
        type: 'success'
      }))}
    />
  );
}
```

### Vibe Coding Pattern

```
/@scout "find auth files" 5
    ↓
Parallel: 5 agents searching
    ↓
Progress: TaskTracker shows each agent
    ↓
Output: Organized file list by category
```

## Key Takeaway

Scout parallelizes file discovery across multiple AI agents (Gemini + OpenCode), delivering organized, actionable file lists in under 5 minutes—even for massive codebases. No guessing where authentication lives or which files handle payments. Scout maps it, you build it.

---

## 🏯 Binh Pháp Alignment

> **用間篇** (Dụng Gián) - Intelligence - Gather market intel

### Zero-Effort Commands

| Gõ lệnh | Agent tự động làm |
|---------|-------------------|
| `/plan` | Tự tạo implementation plan |
| `/code` | Tự implement theo plan |
| `/ship` | Tự test, review, deploy |

📖 [Xem tất cả Commands](/docs/commands)
