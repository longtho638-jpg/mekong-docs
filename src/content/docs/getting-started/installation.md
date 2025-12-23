---
title: Installation
description: How to install AgencyOS - the AI-Native Agency Operating System
section: getting-started
category: getting-started
order: 2
published: true
---

# Installation

This guide will help you install AgencyOS and set up your agency automation environment.

## Video Guide

Prefer video? Watch the complete installation walkthrough:

<div style="text-align: center; padding: 3rem; background: var(--color-bg-tertiary); border-radius: 0.75rem; border: 1px solid var(--color-border); margin-bottom: 1rem;"><div style="font-size: 3rem; margin-bottom: 1rem;">🏯</div><h3 style="margin: 0 0 0.5rem 0;">Demo Video Coming Soon</h3><p style="margin: 0; color: var(--color-text-muted);">Check our documentation to get started</p></div>

## Prerequisites

Before installing AgencyOS, ensure you have:

- **Python** 3.8 or higher
- **Git** for cloning the repository
- **pip** for installing dependencies
- **AgencyOS License Key** (get from [agencyos.network/pricing](/pricing))

## Quick Installation

### Step 1: Clone the Repository

```bash
# Clone AgencyOS Starter
git clone https://github.com/longtho638-jpg/agencyos-starter.git

# Navigate to directory
cd agencyos-starter
```

### Step 2: Install Dependencies

```bash
# Install Python dependencies
pip install -r requirements.txt
```

### Step 3: Activate Your License

```bash
# Activate with your license key
python activate.py YOUR-LICENSE-KEY
```

Replace `YOUR-LICENSE-KEY` with the key you received after purchase.

### Step 4: Verify Installation

```bash
# Show available commands
python -m core.help

# Check installed modules
ls core/
```

## Running Commands

AgencyOS commands are Python modules. Run them like this:

```bash
# Marketing commands
python -m core.marketing_hub

# Sales commands
python -m core.sales_hub

# Finance commands
python -m core.finance_hub

# Strategy (Binh Pháp)
python -m core.strategy_officer
```

## IDE Integration (Recommended)

For the best experience, open in an AI-powered IDE:

### Cursor IDE
[![Open in Cursor](https://img.shields.io/badge/Open%20in-Cursor-blue?style=for-the-badge&logo=cursor)](https://cursor.com)

1. Open Cursor IDE
2. Clone: `git clone https://github.com/longtho638-jpg/agencyos-starter.git`
3. Open the folder in Cursor
4. Use the integrated terminal to run commands

### VS Code
1. Open VS Code
2. Clone and open the agencyos-starter folder
3. Install Python extension
4. Use integrated terminal

## Troubleshooting

### Python not found
```bash
# Check Python version
python --version

# If not found, install Python 3.8+
# macOS: brew install python
# Ubuntu: sudo apt install python3
# Windows: Download from python.org
```

### Permission errors
```bash
# Use pip with user flag
pip install --user -r requirements.txt
```

### License activation failed
- Check your license key is correct
- Ensure internet connection
- Contact support@agencyos.network

## Next Steps

After installation:

1. 📖 Read the [Quick Start Guide](/docs/getting-started/quick-start)
2. 📋 Explore [85+ Commands](/commands)
3. 🖥️ Try the [Interactive Demo](/demo)
4. 💰 Calculate your [ROI](/roi-calculator)

---

**Need help?** Contact us at [hello@agencyos.network](mailto:hello@agencyos.network)
