---
title: "Mekong CLI Commands"
description: "Complete reference for Mekong CLI and business commands"
section: "docs"
---

# Mekong CLI Command Reference

> 🌊 Mekong CLI: Deploy Your Agency in 15 Minutes

---

## 🚀 Quick Start

```bash
# Install Mekong CLI
git clone https://github.com/longtho638-jpg/mekong-cli.git
cd mekong-cli
pip install -r requirements.txt

# Create your first project
python main.py init my-agency
cd my-agency
python main.py setup-vibe --location "Can Tho"
```

---

## 🔧 CLI Commands (11)

### Project Setup

| Command | Description |
|---------|-------------|
| `mekong init <name>` | Initialize new project from template |
| `mekong setup-vibe` | Configure AI voice/tone for your region |
| `mekong generate-secrets` | Create .env file with API keys |
| `mekong mcp-setup` | Setup MCP (Model Context Protocol) servers |

### Deployment

| Command | Description |
|---------|-------------|
| `mekong deploy` | Deploy to Google Cloud Run |

### License Management

| Command | Description |
|---------|-------------|
| `mekong activate --key <key>` | Activate license (Starter/Pro/Enterprise) |
| `mekong status` | Show current license status and quota |

### Testing & Debug

| Command | Description |
|---------|-------------|
| `mekong run-scout <feature>` | Test Scout Agent with a feature |
| `mekong agents` | Show all AI agents status |
| `mekong costs` | Analyze Hybrid Router cost savings |
| `mekong vibes` | Show available Vibe Tuning options |

---

## 🤖 AI Agents (7)

### Quad-Agent System (Core)

| Agent | Role | Icon |
|-------|------|------|
| **Scout** | Thu thập thông tin thị trường | 🔍 |
| **Editor** | Biên tập nội dung | ✏️ |
| **Director** | Đạo diễn video | 🎬 |
| **Community** | Đăng bài & tương tác | 🤝 |

### Mekong-Specific Agents

| Agent | Role | Icon |
|-------|------|------|
| **Market Analyst** | Phân tích giá nông sản ĐBSCL | 📊 |
| **Zalo Integrator** | Tích hợp Zalo OA/Mini App | 💬 |
| **Local Copywriter** | Viết content giọng địa phương | 🎤 |

---

## 🏯 Mekong Business Commands (28)

> Interactive commands with bilingual support (EN/VN)

### Strategy & Planning

| EN Command | VN Command | Questions | Purpose |
|------------|------------|-----------|---------|
| `/business-plan` | `/ke-hoach-kinh-doanh` | 9 | Complete business plan |
| `/market-research` | `/nghien-cuu-thi-truong` | 8 | TAM/SAM/SOM analysis |
| `/growth-strategy` | `/ke-hoach-tang-truong` | 8 | Growth roadmap |

### Customer & Sales

| EN Command | VN Command | Questions | Purpose |
|------------|------------|-----------|---------|
| `/customer-profile` | `/khach-hang` | 7 | Buyer personas |
| `/sales` | `/ban-hang` | 6 | Sales optimization |
| `/sales-strategy` | `/chien-luoc-ban-hang` | 8 | Sales playbook |

### Marketing

| EN Command | VN Command | Questions | Purpose |
|------------|------------|-----------|---------|
| `/marketing` | `/tiep-thi` | 8 | Campaign automation |
| `/marketing-strategy` | `/ke-hoach-tiep-thi` | 9 | Annual marketing plan |
| `/content-marketing` | `/noi-dung-tiep-thi` | 8 | Content strategy |
| `/social-media` | `/y-tuong-social-media` | 7 | Social content ideas |
| `/messaging` | `/thong-diep-tiep-thi` | 7 | Taglines & copy |

### Brand & PR

| EN Command | VN Command | Questions | Purpose |
|------------|------------|-----------|---------|
| `/brand-identity` | `/nhan-dien-thuong-hieu` | 9 | Brand identity system |
| `/pr-plan` | `/ke-hoach-pr` | 7 | PR & communications |

### Specialty

| EN Command | VN Command | Questions | Purpose |
|------------|------------|-----------|---------|
| `/commodity` | `/nong-san` | 5 | Agricultural price analysis |

**[→ Full Mekong Business Commands](/docs/mekong)**

---

## 📦 Core Modules (154)

Mekong CLI includes 154 Python modules for agency automation:

### Hubs (Central Dashboards)
- `marketing_hub.py` - Marketing command center
- `sales_hub.py` - Sales pipeline management
- `finance_hub.py` - Financial overview
- `hr_hub.py` - HR management
- `executive_hub.py` - Executive dashboard

### Generators
- `proposal_generator.py` - Professional proposals
- `content_generator.py` - Multi-format content
- `business_plan_generator.py` - Business planning
- `pitch_deck.py` - Investor presentations

### Binh Pháp (13 Chapters)
- Strategic frameworks based on Binh Pháp
- Located in `core/binh_phap/`

### Integrations
- `telegram_bot.py` - Telegram automation
- `slack_integration.py` - Slack workflows
- `zalo_integrator.py` - Zalo OA/Mini App

---

## 🎤 Vibe Tuning

Configure AI voice for regional audiences:

| Vibe ID | Name | Tone | Keywords |
|---------|------|------|----------|
| `mien-tay` | Miền Tây | Thân thiện, ấm áp | hen, nghen, tui |
| `mien-bac` | Miền Bắc | Lịch sự, trang trọng | ạ, nhé, xin phép |
| `mien-trung` | Miền Trung | Mộc mạc, thật thà | mô, tê, răng, rứa |
| `gen-z` | Gen Z | Trendy, năng động | slay, vibe, chill |
| `professional` | Professional | Chuyên nghiệp | chiến lược, tối ưu |

```bash
mekong setup-vibe --location "Can Tho"
```

---

## 💰 Hybrid Router

Cost-optimized AI routing:

| Provider | Cost/1K tokens | Use Case |
|----------|----------------|----------|
| Llama 3.1 8B | $0.0001 | Simple text |
| Llama 3.1 70B | $0.0006 | Medium tasks |
| Gemini 2.5 Flash | $0.0007 | Vision, long context |
| Gemini 2.5 Pro | $0.006 | Complex reasoning |
| Claude Sonnet | $0.018 | Code, analysis |

**Target: 70% cost reduction** vs GPT-4 only

---

## 📋 License Tiers

| Tier | Videos/Day | Niches | Features |
|------|------------|--------|----------|
| **Starter** | 1 | 1 | Basic template |
| **Pro** | 10 | 10 | White-label, all niches |
| **Enterprise** | Unlimited | All | Custom + support |

```bash
# Check status
mekong status

# Activate Pro
mekong activate --key mk_live_pro_xxxxx
```

---

*Mekong CLI v2.0 | 11 CLI Commands | 28 Business Commands | 154 Core Modules*
