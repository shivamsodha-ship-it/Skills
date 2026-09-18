#!/usr/bin/env bash
# Reproduces the 5-tool Claude Code setup (graphify, gstack, strix skills,
# i-have-adhd plugin, freellmapi) on a fresh machine/codespace.
# Run once per machine: bash claude-tools-setup.sh
set -uo pipefail

say() { printf '\n\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN\033[0m %s\n' "$*" >&2; }

# ---- prerequisites -----------------------------------------------------
command -v claude >/dev/null 2>&1 || { echo "Claude Code CLI not found — install it first."; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git not found — install it first."; exit 1; }

# ---- 1. graphify: codebase knowledge-graph skill (global) --------------
say "graphify"
if ! command -v graphify >/dev/null 2>&1; then
  if command -v pipx >/dev/null 2>&1; then
    pipx install graphifyy
  else
    pip install --user graphifyy
  fi
fi
graphify install --platform claude || warn "graphify install failed"

# ---- 2. gstack: 55-skill Claude Code workflow suite (global) -----------
say "gstack"
if [ ! -d "$HOME/.claude/skills/gstack" ]; then
  mkdir -p "$HOME/.claude/skills"
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$HOME/.claude/skills/gstack"
fi
if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
fi
( cd "$HOME/.claude/skills/gstack" && ./setup ) || warn "gstack setup failed"

# ---- 3. strix: AI pentesting skills (global) ----------------------------
# Authorized security research / CTF use only — see usestrix/strix README.
say "strix skills"
npx --yes skills add usestrix/strix -g -y || warn "strix skills install failed"

# ---- 4. i-have-adhd: terse-output Claude Code plugin (user scope) ------
say "i-have-adhd plugin"
claude plugin marketplace add ayghri/i-have-adhd || warn "marketplace add failed"
claude plugin install i-have-adhd@i-have-adhd || warn "plugin install failed"

# ---- 5. freellmapi: free-tier LLM router (Docker service) --------------
say "freellmapi"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  curl -fsSL https://freellmapi.co/install.sh | bash
  echo "Then: npx freellmapi setup-claude --url http://localhost:3001 --api-key <unified-key-from-dashboard>"
else
  warn "Docker not available/running — skipped freellmapi. Install Docker and re-run this section manually."
fi

say "Done. Restart Claude Code (or open a new session) to pick up the new skills/plugins."
