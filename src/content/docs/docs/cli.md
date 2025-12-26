---
title: "CLI Reference"
description: "Complete reference for Mekong CLI commands"
section: "docs"
---

# Mekong CLI Reference

> 🌊 11 commands to deploy your agency in 15 minutes

---

## 📦 Installation

```bash
# Clone repository
git clone https://github.com/longtho638-jpg/mekong-cli.git
cd mekong-cli

# Install dependencies
pip install -r requirements.txt

# Verify installation
python main.py --help
```

---

## 🚀 Project Commands

### `mekong init <name>`

Initialize a new Hybrid Agent project from the Golden Template.

```bash
python main.py init my-agency
```

**Options:**
- Creates project directory from template
- Starter tier: Basic template (1 niche)
- Pro/Enterprise: Full template (10 niches, white-label)

---

### `mekong setup-vibe`

Configure the AI's voice and tone for your target region.

```bash
python main.py setup-vibe --location "Can Tho" --niche 1
```

**Options:**
- `--niche`: Select from 10 industries
- `--location`: Your target region
- `--tone`: Brand voice style

**Available Niches:**
| # | Niche | Description |
|---|-------|-------------|
| 1 | 🌾 rice-trading | Lúa Gạo |
| 2 | 🐟 fish-seafood | Cá Tra |
| 3 | 🛋️ furniture | Nội Thất |
| 4 | 🏗️ construction-materials | Vật Liệu XD |
| 5 | 🚜 agriculture-tools | Máy Nông Nghiệp |
| 6 | 🏠 real-estate | Bất Động Sản |
| 7 | 🍜 restaurants | Nhà Hàng |
| 8 | 💅 beauty-spa | Thẩm Mỹ Viện |
| 9 | 🚗 automotive | Ô Tô |
| 10 | 📚 education | Trung Tâm Học |

---

### `mekong generate-secrets`

Interactive secret generation for .env file.

```bash
python main.py generate-secrets
```

**Prompts for:**
- SUPABASE_URL
- SUPABASE_KEY
- GOOGLE_API_KEY
- OPENROUTER_API_KEY
- ELEVENLABS_API_KEY

---

### `mekong mcp-setup`

Setup MCP (Model Context Protocol) servers.

```bash
python main.py mcp-setup
```

**Installs:**
- @anthropic/mcp-server-filesystem
- @anthropic/mcp-server-fetch
- @anthropic/mcp-server-playwright

---

## ☁️ Deployment

### `mekong deploy`

Deploy the Hybrid Agent to Google Cloud Run.

```bash
python main.py deploy
```

**Requirements:**
- Google Cloud account configured
- Docker installed
- Valid .env file

---

## 🔐 License Management

### `mekong activate`

Activate your Mekong-CLI license.

```bash
python main.py activate --key mk_live_pro_xxxxx
```

**License Tiers:**

| Tier | Videos/Day | Niches | Features |
|------|------------|--------|----------|
| Starter | 1 | 1 | Basic template |
| Pro | 10 | 10 | White-label, all niches |
| Enterprise | Unlimited | All | Custom + support |

---

### `mekong status`

Show current license status and remaining quota.

```bash
python main.py status
```

**Shows:**
- Current tier
- Activation date
- Daily videos used/limit

---

## 🧪 Testing & Debug

### `mekong run-scout <feature>`

Test Scout Agent with a specific feature.

```bash
python main.py run-scout "product launch"
```

---

### `mekong agents`

Show all AI agents and their status.

```bash
python main.py agents
```

**Output:**
- 4 Quad-Agent System agents
- 3 Mekong-specific agents
- Status of each agent

---

### `mekong costs`

Analyze Hybrid Router cost savings.

```bash
python main.py costs
```

**Shows:**
- Routing strategy explanation
- Tasks routed this month
- Cost comparison vs GPT-4 only
- Provider pricing table

---

### `mekong vibes`

Show available Vibe Tuning options.

```bash
python main.py vibes
```

**Available Vibes:**
| ID | Name | Tone |
|----|------|------|
| mien-tay | Miền Tây | Thân thiện, ấm áp |
| mien-bac | Miền Bắc | Lịch sự, trang trọng |
| mien-trung | Miền Trung | Mộc mạc, thật thà |
| gen-z | Gen Z | Trendy, năng động |
| professional | Professional | Chuyên nghiệp |

---

## 🔗 Related

- [AI Agents](/docs/agents)
- [Business Commands](/docs/mekong)
- [Installation Guide](/docs/getting-started/installation)

---

*Mekong CLI v2.0 | 11 Commands | Python-based*
