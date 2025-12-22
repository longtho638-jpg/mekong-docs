---
title: CLI Overview
description: "Documentation for CLI Overview
description:
section: docs
category: cli
order: 0
published: true"
section: docs
category: cli
order: 0
published: true
---

# Mekong Marketing CLI Overview

Command-line tool for bootstrapping and updating Mekong Marketing projects from private GitHub repository releases.

## What is Mekong Marketing CLI?

**Mekong Marketing CLI** (`ck`) is a command-line tool that downloads and manages Mekong Marketing starter kits from private GitHub repositories. Built with Bun and TypeScript, it provides fast, secure project setup and updates.

**Important:** You need to purchase a Mekong Marketing Starter Kit from [Mekong Marketing.cc](https://mekongmarketing.com) to use this CLI. Without a purchased kit and repository access, the CLI cannot download project templates.

## Key Features

- **Multi-tier GitHub Authentication** - Secure authentication via gh CLI → env vars → keychain → prompt
- **Streaming Downloads** - Fast downloads with progress tracking
- **Smart File Merging** - Updates projects without breaking custom changes
- **Protected Files** - Automatic protection of sensitive files and custom configurations
- **Secure Credential Storage** - Uses OS keychain for token management
- **Beautiful CLI Interface** - Interactive prompts with progress indicators

## Core Commands

### mk init

Initialize or update Mekong Marketing Engineer in your project:

**Note:** This command should be run from the root directory of your project.

```bash
# Interactive mode (recommended)
mk init

# With options
mk init --kit engineer

# Specific version
mk init --kit engineer --version v1.0.0

# With exclude patterns
mk init --exclude "local-config/**" --exclude "*.local"

# Global mode - use platform-specific user configuration
mk init --global
mk init -g --kit engineer
```

**What it does:**
- Downloads specified Mekong Marketing release
- Intelligently merges files
- Preserves your custom changes
- Protects sensitive files
- Maintains custom `.claude/` files

**Options:**
- `--dir <dir>` - Target directory (default: current directory)
- `--kit <kit>` - Kit to use (`engineer` or `marketing`)
- `--version <version>` - Specific version to download (default: latest)
- `--exclude <pattern>` - Exclude files/directories using glob patterns (can be used multiple times)
- `--global, -g` - Use platform-specific user configuration directory

**Global vs Local Configuration:**

By default, Mekong Marketing uses local configuration (`~/.mekong`).

For platform-specific **user-scoped settings**, use the `--global` flag:
- **macOS/Linux**: `~/.claude`
- **Windows**: `%LOCALAPPDATA%\.claude`

Global mode uses user-scoped directories (no sudo required), allowing separate configurations for different projects.

### ck update

Update the Mekong Marketing CLI itself to the latest version:

```bash
# Update CLI to latest
mk update
```

**What it does:**
- Updates the `ck` command-line tool to the latest version
- Does NOT update Mekong Marketing Engineer files (use `mk init` for that)

### mk versions

List available versions of Mekong Marketing releases:

```bash
# Show all available versions
mk versions

# Filter by specific kit
mk versions --kit engineer
mk versions --kit marketing

# Show more versions (default: 30)
mk versions --limit 50

# Include prereleases and drafts
mk versions --all
```

**Options:**
- `--kit <kit>` - Filter by specific kit
- `--limit <limit>` - Number of releases to show (default: 30)
- `--all` - Show all releases including prereleases

## Global Options

All commands support these global options:

### --verbose, -v

Enable verbose logging for debugging:

```bash
mk init --verbose
mk init -v  # Short form
```

**Shows:**
- HTTP request/response details (tokens sanitized)
- File operations (downloads, extractions, copies)
- Command execution steps and timing
- Error stack traces with full context
- Authentication flow details

### --log-file

Write logs to file for sharing:

```bash
mk init --verbose --log-file debug.log
```

**Note:** All sensitive data (tokens, credentials) is automatically sanitized in logs.

## Available Kits

Mekong Marketing offers premium starter kits (purchase required):

- **engineer**: Mekong Marketing Engineer - Engineering toolkit with 14 specialized agents
- **marketing**: Mekong Marketing Marketing - [Coming Soon]

Purchase at [Mekong Marketing.cc](https://mekongmarketing.com) to get repository access.

## Authentication

The CLI requires a **GitHub Personal Access Token (PAT)** to download releases from private repositories.

### Authentication Flow (Multi-Tier Fallback)

1. **GitHub CLI**: Uses `gh auth token` if available
2. **Environment Variables**: Checks `GITHUB_TOKEN` or `GH_TOKEN`
3. **OS Keychain**: Retrieves stored token
4. **User Prompt**: Prompts for token and offers secure storage

### Creating a Personal Access Token

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope (for private repositories)
3. Copy the token

### Setting Token via Environment Variable

```bash
export GITHUB_TOKEN=ghp_your_token_here
```

## Configuration

Configuration stored in `~/.mekong/config.json`:

```json
{
  "github": {
    "token": "stored_in_keychain"
  },
  "defaults": {
    "kit": "engineer",
    "dir": "."
  }
}
```

## Protected Files

These files are **never overwritten** during updates:

- Environment files: `.env`, `.env.local`, `.env.*.local`
- Security files: `*.key`, `*.pem`, `*.p12`
- Dependencies: `node_modules/**`, `.git/**`
- Build outputs: `dist/**`, `build/**`

### Custom .claude Files

Your custom files in `.claude/` directory are automatically preserved:

**Example:**
```
Your project:
  .claude/
    ├── commands/standard.md  (from Mekong Marketing)
    └── commands/my-custom.md (your custom command)

After update:
  .claude/
    ├── commands/standard.md  (updated from release)
    └── commands/my-custom.md (preserved automatically)
```

## Quick Start

```bash
# Install CLI
npm install -g mekong-cli

# Verify installation
mk --version

# Authenticate with GitHub
gh auth login
# OR
export GITHUB_TOKEN=ghp_your_token

# Initialize project
mk init --kit engineer

# Navigate to project
cd my-project

# Start using Mekong Marketing
claude  # Start Mekong CLI
```

## Common Workflows

### Initialize or Update Mekong Marketing Engineer

```bash
# Interactive mode (recommended)
mk init

# Direct with options
mk init --dir my-app --kit engineer

# Specific version
mk init --dir my-app --kit engineer --version v1.0.0

# With exclusions
mk init --exclude "*.log" --exclude "temp/**"

# Update Mekong Marketing Engineer to latest
mk init

# Update to specific version
mk init --version v1.2.0

# Update with exclusions
mk init --exclude "local-config/**" --exclude "*.local"

# Update with verbose output
mk init --verbose
```

### Update the CLI Itself

```bash
# Update ck CLI to latest version
mk update
```

### Check Available Versions

```bash
# List all versions
mk versions

# Filter by kit
mk versions --kit engineer

# Show more releases
mk versions --limit 50
```

## Troubleshooting

### Authentication Failed

**Problem:** "Authentication failed"

**Solutions:**
1. Check if GitHub CLI is authenticated: `gh auth status`
2. Or set environment variable: `export GITHUB_TOKEN=ghp_your_token`
3. Verify token has `repo` scope
4. Check repository access (requires purchased kit)

### Command Not Found

**Problem:** `ck: command not found`

**Solutions:**
```bash
# Reinstall globally
npm install -g mekong-cli

# Check installation
npm list -g mekong-cli

# Restart terminal
```

### Download Fails

**Problem:** "Failed to download release"

**Solutions:**
1. Check internet connection
2. Verify GitHub token is valid: `gh auth status`
3. Confirm you have repository access (purchased kit)
4. Try with verbose flag: `mk init --verbose`

## Version Information

Current version: **1.2.1**

Check version:
```bash
mk --version
```

View help:
```bash
mk --help
mk -h
```

## Next Steps

- [Installation Guide](/docs/docs/cli/installation) - Install Mekong Marketing CLI
- [Getting Started](/docs/getting-started/installation) - Start using Mekong Marketing

---

**Ready to start?** Purchase a kit at [Mekong Marketing.cc](https://mekongmarketing.com), then run `mk init` to initialize your first project.
