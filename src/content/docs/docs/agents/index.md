---
title: "AI Agents"
description: "7 AI agents powering Mekong CLI automation"
section: "docs"
---

# Mekong AI Agents

> 🤖 7 specialized AI agents for agency automation

---

## 🎯 Quad-Agent System

The core 4-agent system for content production:

### 🔍 Scout Agent

**Role:** Thu thập thông tin thị trường

**Capabilities:**
- Analyze git commits to find "shippable units"
- Scan Product Hunt, X, Reddit for trends
- Generate Intelligence Briefs (JSON)

**MCP Tools:**
- git-mcp: Read commit history
- playwright-scraper: Web scraping
- analytics-mcp: Traffic data

```bash
mekong run-scout "AI productivity tools"
```

---

### ✏️ Editor Agent

**Role:** Biên tập nội dung

**Capabilities:**
- Convert code/commits into blog posts
- Generate Twitter threads
- Write video scripts

**Output Formats:**
- Markdown articles
- Social media posts
- Video scripts

---

### 🎬 Director Agent

**Role:** Đạo diễn video

**Capabilities:**
- Generate voiceover (ElevenLabs)
- Render video with FFmpeg
- Add auto-subtitles

**Output:**
- .mp4 files (9:16 for Shorts/Reels)
- .mp4 files (16:9 for YouTube)

**Tools:**
- elevenlabs-mcp: Text-to-Speech
- ffmpeg: Video processing
- genmedia-mcp: Image/Video AI

---

### 🤝 Community Agent

**Role:** Đăng bài & tương tác

**Capabilities:**
- Post to X, Reddit, YouTube
- Manage rate limits
- Track engagement metrics

**MCP Tools:**
- twitter-mcp: X/Twitter API
- reddit-mcp: Reddit API
- youtube-mcp: YouTube upload

---

## 🌾 Mekong-Specific Agents

3 specialized agents for Vietnamese markets:

### 📊 Market Analyst

**Role:** Phân tích giá nông sản ĐBSCL

**Focus:**
- Real-time commodity prices
- Mekong Delta market analysis
- Price trend forecasting

**Use Case:**
```bash
/nong-san "gạo ST25"
/commodity "coffee arabica"
```

---

### 💬 Zalo Integrator

**Role:** Tích hợp Zalo OA/Mini App

**Capabilities:**
- Zalo Official Account automation
- Mini App integration
- Vietnamese messaging optimization

---

### 🎤 Local Copywriter

**Role:** Viết content giọng địa phương

**Vibes Supported:**
| Region | Tone | Keywords |
|--------|------|----------|
| Miền Tây | Thân thiện, ấm áp | hen, nghen, tui |
| Miền Bắc | Lịch sự, trang trọng | ạ, nhé, xin phép |
| Miền Trung | Mộc mạc, thật thà | mô, tê, răng, rứa |
| Gen Z | Trendy, năng động | slay, vibe, chill |

---

## 📊 Agent Pipeline

```
Git Commit → Scout → Intelligence Brief
                ↓
         Editor → Blog + Script
                ↓
         Director → Video
                ↓
         Community → Published
```

---

## 🔧 Agent Status

Check all agents with:

```bash
mekong agents
```

**Output:**
```
🤖 MEKONG-CLI AI Agents

   Quad-Agent System:
      🔍 Scout: Thu thập thông tin [Ready]
      ✏️ Editor: Biên tập nội dung [Ready]
      🎬 Director: Đạo diễn video [Ready]
      🤝 Community: Đăng bài & tương tác [Ready]

   Mekong-Specific Agents:
      📊 Market Analyst: Phân tích giá nông sản [Ready]
      💬 Zalo Integrator: Tích hợp Zalo OA [Ready]
      🎤 Local Copywriter: Content giọng địa phương [Ready]

   Total: 7 agents ready
```

---

## 🔗 Related

- [CLI Commands](/docs/cli)
- [Business Commands](/docs/mekong)
- [Workflows](/docs/workflows)

---

*Mekong CLI v2.0 | 7 AI Agents | Quad-Agent + Mekong-Specific*

---

## 🏯 Binh Pháp Alignment

> **計篇** (Kế) - Strategic calculations

### Zero-Effort Commands

| Gõ lệnh | Agent tự động làm |
|---------|-------------------|
| `/plan` | Tự tạo implementation plan |
| `/code` | Tự implement theo plan |
| `/ship` | Tự test, review, deploy |

📖 [Xem tất cả Commands](/docs/commands)
