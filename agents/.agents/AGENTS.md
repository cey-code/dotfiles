# Agent rules

Shared global instructions for all AI coding agents (Claude Code, Codex, …), applied across every project. Project-specific rules live in each repo's `AGENTS.md` and take precedence on conflicts.

## Attribution (hard rule)
- Never mention Claude as a co-author or contributor anywhere: commits, branch names, PR titles, PR descriptions, PR comments. Everything comes from me (ceyhuntopcu).
- No "Generated with Claude Code" footers or similar.

## Plan before doing
- Never execute anything without a thorough plan, unless I explicitly tell you to.
- Make a deliberate plan, then give me a plain-English summary of it:
  - What's the issue
  - How we're fixing it
  - Why that's the right fix
- Investigate from scratch. Don't base decisions on existing tickets: read the code, then come back with suggestions and ideas.

## Decisions
- I make every important decision: architecture, system design, anything big.
- Don't decide things on your own. If you have to, tell me straight away.
- Recommendations are welcome: give me the options, their trade-offs, and which one you'd pick.

## Communication
- Explain everything clearly, in plain English.
- Keep separate things separate: one point per item. Never fold several decisions or changes into one.
- When I ask for a TL;DR or a quick answer, keep it short.

## Order of work
- A task that touches the database, backend and frontend goes in that order: database layer first, then backend, then frontend.
- If there's no database work: backend first, then frontend.
- Separate PRs, not stacks. Each PR is merged before the next one starts.

## Artifacts
- Show me ERDs, UI/UX changes and similar as artifacts before any coding starts.

## Code
### Frontend
- Always use the existing builders, components and primitives.
- Never modify a primitive. If you absolutely must, ask me first.

### Backend
- Always investigate the full blast radius, code quality and code duplication.
- Never create a new helper for one use case when a similar helper already exists.

### Comments
- Comment only when the code can't speak for itself: a non-obvious reason, a workaround, a hidden constraint.
- Keep each comment short, ideally one line. Say why, not what.

### Tests
- Add tests only for new behaviour or complex logic.
- Don't test trivial or pass-through code, and don't add a test for every change.

### Repo practices
- Follow the repo's existing code practices. When unsure how something is done, look at how Ervin, Karim or Sehal do it.

## Git workflow
- When starting a new task, create its branch first and immediately give me the copy-paste checkout command.
- Local sessions (this Mac: app or terminal): never commit or push unless I explicitly ask.
- Cloud sessions: I can't see cloud changes locally, so commit and push in batches as you go. That lets me pull, review and run the code locally.
