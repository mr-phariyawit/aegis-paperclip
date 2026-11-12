# AEGIS on Paperclip

AI Agent Company running on [Paperclip](https://github.com/paperclipai/paperclip) — 13 autonomous agents with 5-Gate Quality System.

## Company: AEGIS

**Mission:** Production-grade autonomous software delivery via 13 AI agents. 14-Stage SDLC Pipeline with 5-Gate Quality System and ISO 29110 Compliance.

## Org Chart

```
Mother Brain (CEO) - claude-opus-4-6
  └── Navi (PM) - claude-opus-4-6
        ├── Sage (CTO) - claude-opus-4-6
        │     └── Bolt (Engineer) - claude-sonnet-4-6
        ├── Vigil (QA - Gate 1) - claude-sonnet-4-6
        ├── Havoc (Devil's Advocate) - claude-opus-4-6
        ├── Forge (Scanner) - claude-haiku-4-5
        ├── Pixel (UX Designer) - claude-sonnet-4-6
        ├── Muse (Content Writer) - claude-haiku-4-5
        ├── Sentinel (QA Lead - Gate 2) - claude-sonnet-4-6
        │     └── Probe (QA Executor) - claude-haiku-4-5
        ├── Scribe (Compliance - Gate 3) - claude-haiku-4-5
        └── Ops (DevOps - Gate 4-5) - claude-sonnet-4-6
```

## Active Project: คำต้องห้าม (Forbidden Words)

Mobile-first web party game based on the Thai viral game by เทพลีลา.

- **Engine:** Construct 3 (HTML5 export)
- **Multiplayer:** Colyseus (WebSocket game server)
- **Concept:** Players hold phones showing a secret word — communicate by speaking & body language — trick others into saying their forbidden word

## Data Files

| File | Description |
|------|-------------|
| `company.json` | AEGIS company config |
| `agents.json` | 13 agent definitions with roles & hierarchy |
| `goals.json` | Company & team goals (5-gate system) |
| `projects.json` | Project workspace config |
| `issues.json` | SDLC pipeline issues |
| `routines.json` | Heartbeat, standup, security scan schedules |
| `company-files/` | Agent instruction files (AGENTS.md, SOUL.md, etc.) |

## Restore

```bash
# 1. Install Paperclip
git clone https://github.com/paperclipai/paperclip.git
cd paperclip && pnpm install && pnpm dev

# 2. Import data via API
# Company, agents, goals, issues are in JSON files
# Use curl to POST each to http://127.0.0.1:3100/api/
```

## Based on AEGIS Framework

Inspired by [AEGIS-Team](https://github.com/phariyawitjiap-aeternix/AEGIS-Team) v8.3 — adapted for Paperclip orchestration.
