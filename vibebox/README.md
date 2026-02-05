# VibBox 🐳

> Containerized Mistral Vibe Development Environment

Run [Mistral Vibe CLI](https://github.com/mistralai/vibe) in isolated, reproducible Docker environments with per-project profiles.

## Features

- **Containerized & isolated** — Your code runs in a sandboxed Docker container
- **Per-project isolation** — Separate images, configs, and shell history per project
- **Development profiles** — TypeScript/Bun/Expo, PHP/Composer, and more
- **Multi-instance** — Run multiple projects in parallel without conflicts
- **Ollama support** — Use local LLMs with auto-detection
- **Cross-platform** — macOS (arm64) and Linux (amd64/arm64)
- **Modern shell** — zsh with oh-my-zsh, fzf, ripgrep, and syntax highlighting

## Quick Start

**Install VibBox:**

```bash
curl -fsSL https://raw.githubusercontent.com/TODO_GITHUB_USER/vibebox/main/install.sh | bash
```

**Set your API key:**

```bash
export MISTRAL_API_KEY="your-api-key"
```

**Run Vibe in any project:**

```bash
cd your-project
vibebox
```

## Usage

```bash
vibebox                  # Launch Mistral Vibe in container
vibebox shell            # Open interactive zsh shell
vibebox info             # Show project and system info
vibebox build            # Build the Docker image
vibebox rebuild          # Clean rebuild the image
vibebox clean            # Remove project data/image
vibebox profiles         # List available profiles
vibebox profile <name>   # Install a profile
vibebox install <pkg>    # Add apt packages to image
vibebox help             # Show help
```

## Profiles

| Profile | What it installs |
|---------|------------------|
| `typescript` | Bun, TypeScript, tsx, Expo CLI, EAS CLI, React Native |
| `php` | PHP 8.x + extensions, Composer, Laravel Installer, PHPUnit |

Install a profile:

```bash
vibebox profile typescript
```

## Ollama (Local Models)

VibBox auto-detects Ollama running on your host machine.

```bash
# Start Ollama on your host
ollama serve

# VibBox detects it automatically
vibebox shell

# Inside the container, use local models
vibe --provider ollama --model devstral-small:24b
```

Or set `OLLAMA_HOST` explicitly:

```bash
export OLLAMA_HOST="http://your-ollama-server:11434"
vibebox
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                           HOST                                  │
│  ┌──────────────┐     ┌──────────────────────────────────────┐  │
│  │  Project     │     │  ~/.vibebox/                         │  │
│  │  Directory   │     │    └── <project>/                    │  │
│  │  (your code) │     │          ├── .vibe/    (vibe config) │  │
│  └──────┬───────┘     │          ├── .config/  (tool config) │  │
│         │             │          └── .zsh_history            │  │
│         │             └────────────────┬─────────────────────┘  │
│         │                              │                        │
│ ════════╪══════════════════════════════╪═══════════════════════ │
│         │        Docker boundary       │                        │
│         ▼                              ▼                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                 VibBox Container                        │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │    │
│  │  │ /workspace  │  │ /home/vibe/ │  │ Mistral Vibe    │  │    │
│  │  │ (your code) │  │ .vibe/      │  │ + uv + Python   │  │    │
│  │  │             │  │ .zsh_history│  │ + zsh + tools   │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `MISTRAL_API_KEY` | Your Mistral API key (required for API usage) |
| `OLLAMA_HOST` | Ollama server URL (optional, auto-detected if local) |

## Inspired By

VibBox is inspired by [ClaudeBox](https://github.com/1rgs/ClaudeBox), which provides a similar containerized environment for Claude Code.

## License

MIT
