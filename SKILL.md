---
name: multi-agent-collab
description: Initialize, coordinate, and maintain an asymmetric multi-agent workspace (Antigravity/Gemini, OpenAI Codex, and Claude/Agent-3) using Herdr, a permanent AGENT_HUB.md handbook, and an active COLLAB_SESSION.md working blackboard for token-efficient, file-based collaboration.
---

# Multi-Agent Collaboration Skill (`multi-agent-collab`)

## Purpose
Establishes and governs a structured, token-efficient **Multi-Agent Asymmetric Workspace** across multiple AI coding agents (Antigravity/Gemini, OpenAI Codex, and Claude Code/Agent-3) operating in **Herdr** (or tmux).

It replaces noisy, context-bloating terminal prompt injection with the **"Blackboard + Thin Signal" Pattern**:
- **`AGENT_HUB.md`**: Permanent project handbook, team architecture, invariants, and safety boundaries.
- **`COLLAB_SESSION.md`**: Active per-session working blackboard where tasks, constraints, and test criteria are posted.
- **Herdr Socket / CLI**: Used strictly as a 1-line "doorbell" poke (`herdr agent prompt <agent> "Task ready in COLLAB_SESSION.md" --wait`).

---

## 1. When to Use This Skill
Activate this skill whenever:
- The user asks to "set up multi-agent collaboration", "bring in Codex/Claude", or "run agents together".
- A project has multiple agents running in Herdr panes (e.g. Codex on the left, Antigravity/Claude on the right).
- Working with models of asymmetrical cost and reasoning strength (e.g. high-cost reasoning models like GPT-6-Luna alongside fast, large-context models like Gemini Flash).
- A complex task requires separation between research/pre-flight, code authoring, and independent audit.

---

## 2. The Asymmetric Team Roles

To protect quota, minimize token spend on premium models, and prevent context rot:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Human Principal (User)                            │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ High-level goals & approvals
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 Antigravity (agy) [Lead Architect & Preparer]               │
│  • Fast, 1M+ context window, rich tool ecosystem (web search, files, shell) │
│  • Pre-flights dependencies, reads background docs, explores data           │
│  • Writes unambiguous, pre-digested task cards in COLLAB_SESSION.md         │
│  • Runs test harnesses, audits regressions, and manages Herdr signaling     │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Thin 10-word Herdr Signal
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                   Codex (codex) [Principal Engineer & Closer]               │
│  • Premium reasoning (GPT-6-Luna High)                                      │
│  • Authors complex algorithms, tricky refactors, and core business logic    │
│  • Solves subtle edge cases and performs mathematical/clinical derivation   │
│  • Single-turn execution directly from COLLAB_SESSION.md to conserve tokens │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Optional peer delegation
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 Agent 3 / Claude Code [Specialist Builder & Auditor]        │
│  • Large-scale multi-file refactoring, test suite authoring                 │
│  • Parallel branch implementation, secondary code review                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. The "Blackboard + Thin Signal" Operating Protocol

Agents **never pass long prompts, raw files, or code blocks through terminal CLI buffers**. Instead, the filesystem is the shared state:

```
[ Preparer (Antigravity) ] ──(1. Writes Task)──► [ COLLAB_SESSION.md ] ◄──(3. Reads Spec)── [ Closer (Codex) ]
           │                                                                                     │
           └──(2. Pokes via Herdr: "Task ready in COLLAB_SESSION.md")────────────────────────────┘
                                                                                                 │
[ Preparer (Antigravity) ] ◄──(5. Detects 'done', runs tests, reports)──(4. Implements code)─────┘
```

### The 5 Execution Steps:
1. **Pre-flight & Prepare (Antigravity)**:
   - Check dependencies, locate exact files, inspect data.
   - Populate `COLLAB_SESSION.md` with: Objective, Exact Input Files (with line numbers), Strict Constraints, and Acceptance Criteria (exact test commands).
2. **Thin Signal (Herdr)**:
   - Send a 1-line poke via Herdr CLI without prompt fluff:
     ```bash
     herdr agent prompt codex "Task ready in COLLAB_SESSION.md. Run self-check when done." --wait
     ```
3. **Focused Execution (Codex / Assignee)**:
   - The assigned agent reads `COLLAB_SESSION.md` from disk.
   - Uses full reasoning to author the implementation cleanly.
   - Updates `Status: Verification` in `COLLAB_SESSION.md`.
4. **Audit & Verification (Antigravity)**:
   - Antigravity detects that the agent is `done`.
   - Runs the test suite and self-checks in PowerShell.
   - Inspects the git diff.
5. **Closeout**:
   - If tests pass: Antigravity marks `Status: Completed` in `COLLAB_SESSION.md`.
   - If tests fail: Antigravity extracts the exact 5-line stack trace and posts it to `COLLAB_SESSION.md` for a rapid 1-shot fix.

---

## 4. How to Initialize in a New Project

When bootstrapping this setup in any project:

### Step 1: Create `AGENT_HUB.md` in the Project Root
Write a project-specific team handbook following the template in [Appendix A](#appendix-a-agent_hubmd-template). Define:
- Project clinical/technical objective.
- Immutable safety guardrails (e.g. untouchable data directories, virtual environment paths).
- Role allocations.
- Invariants & decision log location.

### Step 2: Create `COLLAB_SESSION.md` in the Project Root
Initialize the per-session blackboard following the template in [Appendix B](#appendix-b-collab_sessionmd-template). Define:
- Active session metadata and date.
- Initial task card (`TASK-001`).
- Backlog queue.

### Step 3: Arrange Herdr Panes
In Herdr, configure the workspace layout:
```bash
# Verify current pane
herdr pane layout --pane "$HERDR_PANE_ID"

# Split pane to the right or down preserving working directory
herdr pane split --current --direction right --cwd "$PWD" --no-focus

# Start Codex in the sibling pane
herdr agent start codex --kind codex --pane <target-pane-id>
```

---

## 5. Golden Rules for Cost & Stability

1. **Protect Codex Tokens**:
   - Never let Codex wander across directories or read raw logs.
   - Keep Codex turns focused: 1 task spec $\to$ 1 authoritative diff.
2. **Never Touch Protected Data**:
   - Canonical raw datasets, journals, and credentials must be declared read-only in `AGENT_HUB.md`.
3. **Always Run Self-Checks Before Declaring Success**:
   - No task is marked `Completed` without green test assertions.
4. **Preserve Human in the Loop**:
   - The user can inspect or edit `COLLAB_SESSION.md` at any time before an agent runs.

---

## Appendix A: `AGENT_HUB.md` Template

```markdown
# AGENT_HUB — Multi-Agent Coordination Center
**Project**: <Project Name>
**Standard**: <Production / Research / RUO>

## 1. Purpose & Quick Start
This document is the enduring source of truth for all AI agents working in this project.
1. Read this file (`AGENT_HUB.md`) to understand project guardrails and roles.
2. Review project decisions / specifications.
3. Check `COLLAB_SESSION.md` for active tasks.
4. Coordinate via file-based blackboard; do not pass long prompts over CLI buffers.

## 2. Architecture & Tech Stack
- Core runtime / Language / Frameworks
- Invariants & design rules

## 3. Strict Safety Guardrails
- Protected directories: <e.g. data/raw, cases/>
- Virtual environment location: <e.g. C:\venvs\<ProjectName>>
- Test command requirement: <e.g. pytest / python -m src... --self-check>

## 4. Agent Role Matrix
- **Lead Architect & Preparer**: Antigravity (Scouting, file checks, test running, task packaging)
- **Principal Engineer & Closer**: Codex (Core algorithmic logic, complex refactors, single-turn execution)
- **Specialist / Builder**: Agent 3 / Claude (Parallel branches, test suites, large edits)

## 5. Directory Map
<List key files and their purposes>
```

---

## Appendix B: `COLLAB_SESSION.md` Template

```markdown
# COLLAB_SESSION — Active Working Board
**Reference**: See `AGENT_HUB.md` for invariants, safety rules, and role guidelines.

## 1. Active Session Metadata
- **Date**: <YYYY-MM-DD>
- **Active Agents**: <agy, codex, agent_3>
- **Current Phase**: <Milestone / Phase Name>
- **Blockers**: <Any human or external blockers>

## 2. Active Task Card
- **Task ID**: TASK-001
- **Task Title**: <Title>
- **Assigned Agent**: <agy | codex | agent_3>
- **Status**: Ready <!-- Ready | In-Progress | Verification | Completed | Blocked -->
- **Priority**: <Normal | High | Urgent>

### Objective
<Clear 1-2 sentence description of what needs to be accomplished>

### Context & Input Files
- Source file: `<path/to/file.py>` (lines X–Y)
- Dependency: `<path/to/other.py>`

### Constraints
1. <Constraint 1>
2. <Constraint 2>

### Acceptance Criteria
- [ ] Code implemented without modifying protected files
- [ ] Test command `<test command>` passes with 0 failures

## 3. Up Next (Queue)
- `TASK-002`: <Next task title> (Assigned: <agent>)

## 4. Live Scratchpad & Outputs
<Diff summaries, test outputs, or diagnostic notes>
```
