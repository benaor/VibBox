# VibBox 🐳

Containerized Mistral Vibe Development Environment — inspired by [ClaudeBox](https://github.com/RchGrav/claudebox), adapted for [Mistral Vibe CLI](https://github.com/mistralai/mistral-vibe).

## How it works

```
┌──────────────────────────────────────────────────────┐
│  Host Machine                                        │
│                                                      │
│  ~/projects/my-app/  ◄── your code                   │
│  ~/.vibebox/my-app/  ◄── persistent state per project│
│       ├── .vibe/          (auth, config)             │
│       ├── .config/        (tool configs)             │
│       └── firewall/       (network allowlist)        │
│                                                      │
│  ┌────────────────────────────────────────────┐      │
│  │  Docker: vibebox-my-app                    │      │
│  │                                            │      │
│  │  Debian + Python 3.12 + uv                 │      │
│  │  Mistral Vibe CLI (via uv tool install)    │      │
│  │  zsh + oh-my-zsh + fzf + ripgrep           │      │
│  │                                            │      │
│  │  /workspace ◄─── bind mount (your code)    │      │
│  │  ~/.vibe    ◄─── bind mount (persistent)   │      │
│  │                                            │      │
│  │  Firewall: only allowlisted domains        │      │
│  └────────────────────────────────────────────┘      │
└──────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# 1. Clone & install
git clone https://github.com/your-user/vibebox.git
chmod +x vibebox/vibebox
ln -s $(pwd)/vibebox/vibebox ~/.local/bin/vibebox

# 2. Set your Mistral API key
export MISTRAL_API_KEY=your-key-here

# 3. Go to any project and launch
cd ~/projects/my-app
vibebox
```

## Commands

|Command                |Description                         |
|-----------------------|------------------------------------|
|`vibebox`              |Launch Mistral Vibe in the container|
|`vibebox shell`        |Open a zsh shell in the container   |
|`vibebox info`         |Show project info and status        |
|`vibebox build`        |Build/rebuild the Docker image      |
|`vibebox rebuild`      |Force clean rebuild                 |
|`vibebox clean`        |Remove project data / image         |
|`vibebox install <pkg>`|Install apt packages in the image   |
|`vibebox allowlist`    |Edit network firewall rules         |

## Architecture: ClaudeBox vs VibBox

|Aspect      |ClaudeBox                  |VibBox             |
|------------|---------------------------|-------------------|
|CLI tool    |`claude` (Node.js/npm)     |`vibe` (Python/uv) |
|Package     |`@anthropic-ai/claude-code`|`mistral-vibe`     |
|API key env |`ANTHROPIC_API_KEY`        |`MISTRAL_API_KEY`  |
|Config dir  |`~/.claude/`               |`~/.vibe/`         |
|Data dir    |`~/.claudebox/`            |`~/.vibebox/`      |
|Runtime     |Node.js via nvm            |Python 3.12 via uv |
|Image naming|`claudebox-<project>`      |`vibebox-<project>`|

## What to add next

- [ ] **Profiles system** — pre-configured stacks (like ClaudeBox’s `claudebox profile python ml`)
- [ ] **Firewall enforcement** — iptables rules from the allowlist
- [ ] **Self-extracting installer** — `.run` file like ClaudeBox
- [ ] **Tmux integration** — socket mounting for multi-pane
- [ ] **Saved flags** — persist default CLI args
- [ ] **Local model support** — Ollama/vLLM inside the container for Devstral Small 2 (24B)

## License

MIT
