# pi config

Symlinked into `~/.pi/agent/`:

| dotfiles | target |
| --- | --- |
| `pi/AGENTS.md` | `~/.pi/agent/AGENTS.md` |
| `pi/settings.json` | `~/.pi/agent/settings.json` |
| `pi/prompts/` | `~/.pi/agent/prompts/` |
| `pi/skills/` | `~/.pi/agent/skills/` |

Setup:

```sh
cd ~/.pi/agent
ln -sfn ~/dotfiles/pi/AGENTS.md AGENTS.md
ln -sfn ~/dotfiles/pi/settings.json settings.json
ln -sfn ~/dotfiles/pi/prompts prompts
ln -sfn ~/dotfiles/pi/skills skills
```

Prompt templates (`/name`) were ported from the opencode primary agents; skills
(model-invoked) from the opencode subagents. pi has no subagent dispatch, so
`/review` runs the three review passes itself and synthesizes them.
