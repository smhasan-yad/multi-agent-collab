param(
    [string]$ProjectName = (Split-Path -Leaf (Get-Location)),
    [string]$Description = "Multi-agent collaborative software engineering workspace.",
    [string]$TargetDir = (Get-Location)
)

$ErrorActionPreference = "Stop"

$hubFile = Join-Path $TargetDir "AGENT_HUB.md"
$sessionFile = Join-Path $TargetDir "COLLAB_SESSION.md"

# 1. Generate AGENT_HUB.md if missing
if (-not (Test-Path $hubFile)) {
    $hubContent = @"
# AGENT_HUB — Multi-Agent Coordination Center
**Project**: $ProjectName
**Description**: $Description
**Standard**: Production-grade, reproducible multi-agent engineering.

---

## 1. Purpose & Quick Start
This document is the enduring source of truth for all AI agents working in this project.
1. Read this file (``AGENT_HUB.md``) to understand project guardrails and roles.
2. Check ``COLLAB_SESSION.md`` for active tasks and ongoing work.
3. Coordinate via the file-based blackboard; do not pass long prompts over CLI buffers.

---

## 2. Asymmetric Team Roles
- **Lead Architect & Preparer** (Antigravity / agy):
  - Gathers context, checks dependencies, and writes unambiguous task cards in ``COLLAB_SESSION.md``.
  - Runs test suites, validates regressions, and sends lightweight Herdr doorbell pokes.
- **Principal Engineer & Closer** (Codex / codex):
  - Receives focused, pre-digested task specs from ``COLLAB_SESSION.md``.
  - Authors complex algorithmic logic, difficult refactors, and core implementation in a single, high-leverage turn.
- **Specialist / Builder** (Agent 3 / Claude Code - Extensible):
  - Handles parallel workstreams, massive multi-file rewrites, or independent code audits.

---

## 3. Strict Safety Guardrails
1. **Never Touch Protected Data**: Canonical datasets, secrets, and journals are strictly read-only.
2. **Deterministic Verification**: Every code change must pass project tests/assertions before being marked complete.
3. **Blackboard Interaction**: Agents do not pass raw code blocks via terminal CLI prompts. All specs live in ``COLLAB_SESSION.md``.

---

## 4. Directory Map
- ``AGENT_HUB.md``: Permanent team rules and architecture.
- ``COLLAB_SESSION.md``: Active session blackboard.
"@
    [System.IO.File]::WriteAllText($hubFile, $hubContent, [System.Text.Encoding]::UTF8)
    Write-Host "[+] Created: $hubFile" -ForegroundColor Green
} else {
    Write-Host "[!] Found existing: $hubFile (skipping)" -ForegroundColor Yellow
}

# 2. Generate COLLAB_SESSION.md if missing
if (-not (Test-Path $sessionFile)) {
    $dateStr = (Get-Date).ToString("yyyy-MM-dd")
    $sessionContent = @"
# COLLAB_SESSION — Active Working Board
**Protocol Reference**: See ``AGENT_HUB.md`` for invariants, safety rules, and role guidelines.
**Rule**: Update this board at each handoff step. Never inject raw code blocks or long prompts over terminal buffers.

---

## 1. Active Session Metadata
- **Date**: $dateStr
- **Active Agents**: agy (Lead Architect/Preparer), codex (Principal Engineer/Closer)
- **Current Phase**: Initial Setup & Scaffolding
- **Active Blockers**: None

---

## 2. Active Task Card

> [!NOTE]
> When assigning a task to Codex, Antigravity fills this card and sends a 1-line Herdr poke:  
> ``herdr agent prompt codex "Task ready in COLLAB_SESSION.md. Run self-check when done." --wait``

- **Task ID**: TASK-001
- **Task Title**: Project Scaffolding and Environment Verification
- **Assigned Agent**: agy
- **Status**: Ready <!-- Values: Ready | In-Progress | Verification | Completed | Blocked -->
- **Priority**: Normal

### Objective
Verify that the project environment, dependencies, and test harnesses run cleanly.

### Context & Input Files
- Configuration files and project entrypoints.

### Constraints
1. Do not modify protected files or raw datasets.
2. Ensure all existing tests pass.

### Acceptance Criteria
- [ ] Environment verified
- [ ] Baseline tests passing

---

## 3. Up Next (Queue)
- ``TASK-002``: Core feature implementation (Assigned: codex)

---

## 4. Live Scratchpad & Agent Output
*(Agents post key findings, verification results, or diff summaries here)*
"@
    [System.IO.File]::WriteAllText($sessionFile, $sessionContent, [System.Text.Encoding]::UTF8)
    Write-Host "[+] Created: $sessionFile" -ForegroundColor Green
} else {
    Write-Host "[!] Found existing: $sessionFile (skipping)" -ForegroundColor Yellow
}
