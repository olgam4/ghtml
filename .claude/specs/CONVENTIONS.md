# Spec Conventions

## Directory Structure

Each feature has its own spec folder:

```
.claude/specs/
├── _templates/              # Templates for new specs
│   ├── README.md
│   ├── requirements.md
│   └── design.md
├── <feature>/
│   ├── README.md            # Overview and navigation
│   ├── requirements.md      # EARS requirements
│   ├── design.md            # Architecture
│   └── research/            # Investigation notes
│       └── *.md
└── CONVENTIONS.md           # This file
```

## EARS Requirements Syntax

Requirements use EARS (Easy Approach to Requirements Syntax) for clarity:

### Event-Driven (most common)
```
WHEN <trigger event>
THE <system component> SHALL <expected behavior>
```

Example:
```
WHEN a user submits invalid credentials
THE auth service SHALL return a 401 error
AND log the failed attempt
```

### State-Driven
```
WHILE <system is in state>
THE <system component> SHALL <maintain behavior>
```

Example:
```
WHILE the rate limit is exceeded
THE API SHALL reject requests with 429 status
```

### Complex (state + event)
```
WHILE <precondition>
WHEN <trigger event>
THE <system component> SHALL <expected behavior>
```

Example:
```
WHILE CI checks are passing
WHEN PR has no merge conflicts
THE merger agent SHALL auto-merge the PR
```

## Linking Specs to Beads

Epics and specs are linked by naming convention: epic name matches spec folder name.

### Create epic linked to spec:
```bash
# Creates epic with label spec:<name> and notes pointing to spec folder
just new-epic feature-name
```

### Create task under epic:
```bash
just new-task <epic-id> "Task description"
```

### Query by spec:
```bash
# Find epic for a spec
bd list --json | jq '.[] | select(.labels[]? | contains("spec:feature-name"))'

# Find tasks under an epic
bd list --parent <epic-id>
```

## Workflow

1. `just new-spec feature-name` - Create spec folder with templates
2. Edit `requirements.md` with EARS requirements
3. Edit `design.md` with architecture
4. `just new-epic feature-name` - Create linked epic in Beads
5. `just new-task <epic-id> "Task"` - Create tasks under epic
