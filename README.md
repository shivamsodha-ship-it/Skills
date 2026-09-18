# claude-tools-setup

One script to reproduce a Claude Code environment with:

- **graphify** — codebase-to-knowledge-graph skill
- **gstack** — 55-skill Claude Code workflow suite
- **strix** — AI pentesting skills (authorized security research / CTF use only)
- **i-have-adhd** — terse-output Claude Code plugin
- **freellmapi** — self-hosted free-tier LLM router (Docker)

## Usage

On any new machine with Claude Code, git, and (ideally) Docker already installed:

```bash
curl -fsSL https://raw.githubusercontent.com/shivamsodha-ship-it/claude-tools-setup/main/install.sh | bash
```

or clone and run locally:

```bash
git clone https://github.com/shivamsodha-ship-it/claude-tools-setup.git
cd claude-tools-setup
bash install.sh
```

Everything installs to your user-level `~/.claude` config, so it's available in every project you open with Claude Code on that machine — this script needs to be re-run on each new machine, since Claude Code has no built-in cross-machine sync for skills/plugins.

Re-running is safe — each step skips work that's already done.
