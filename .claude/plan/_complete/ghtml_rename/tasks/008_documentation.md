# Task 008: Update Documentation

## Description

Update all documentation files to reflect the new `ghtml` naming, including README, CLAUDE.md, CODEBASE.md, and any other markdown files.

## Dependencies

- Task 007: Justfile

## Success Criteria

1. README.md fully updated with new name and examples
2. CLAUDE.md updated with new CLI commands
3. .claude/CODEBASE.md updated with new module paths
4. All badge URLs point to new repository name
5. No references to `lustre_template_gen` or `.lustre` remain in docs

## Implementation Steps

### 1. Update README.md

**Title and branding:**
```markdown
# Before
<h1 align="center">lustre_template_gen</h1>
<img src="assets/logo.png" alt="lustre_template_gen logo" width="200" />

# After
<h1 align="center">ghtml</h1>
<img src="assets/logo.png" alt="ghtml logo" width="200" />
```

**Badge URLs:**
```markdown
# Before
<a href="https://github.com/burakcorekci/lustre_template_gen/actions/...
<a href="https://hex.pm/packages/lustre_template_gen">...
<a href="https://hexdocs.pm/lustre_template_gen/">...

# After
<a href="https://github.com/burakcorekci/ghtml/actions/...
<a href="https://hex.pm/packages/ghtml">...
<a href="https://hexdocs.pm/ghtml/">...
```

**Installation:**
```markdown
# Before
gleam add lustre_template_gen@1

# After
gleam add ghtml@1
```

**CLI commands:**
```markdown
# Before
gleam run -m lustre_template_gen

# After
gleam run -m ghtml
```

**Template examples:**
```markdown
# Before
Create `src/components/greeting.lustre`:

# After
Create `src/components/greeting.ghtml`:
```

### 2. Update CLAUDE.md

```markdown
# Update CLI commands in Quick Reference
- `just run` - Run CLI (gleam run -m ghtml)
```

### 3. Update .claude/CODEBASE.md

**Module paths:**
```markdown
# Before
### `src/lustre_template_gen.gleam` - CLI Entry Point
### `src/lustre_template_gen/parser.gleam` - Parser
import lustre_template_gen/...

# After
### `src/ghtml.gleam` - CLI Entry Point
### `src/ghtml/parser.gleam` - Parser
import ghtml/...
```

**File extension references:**
```markdown
# Before
.lustre file → Parser → ...
src/components/user_card.lustre

# After
.ghtml file → Parser → ...
src/components/user_card.ghtml
```

**Template syntax section:**
```markdown
# Update any file name examples from .lustre to .ghtml
```

### 4. Update .claude/SUBAGENT.md (if exists)

Update any CLI or file extension references.

### 5. Update CONTRIBUTING.md

Update any references to the old name or extension.

### 6. Verify No Old References

```bash
grep -r "lustre_template_gen" *.md .claude/*.md
grep -r "\.lustre" *.md .claude/*.md
```

## Verification Checklist

- [ ] README.md title updated to "ghtml"
- [ ] All badge URLs point to ghtml repository
- [ ] Installation shows `gleam add ghtml@1`
- [ ] All CLI examples use `gleam run -m ghtml`
- [ ] All template examples use `.ghtml` extension
- [ ] CLAUDE.md updated
- [ ] .claude/CODEBASE.md updated
- [ ] `grep -r "lustre_template_gen" *.md .claude/` returns no results
- [ ] `grep -r "\.lustre" *.md .claude/` returns no results (except intentional history/comparison)

## Notes

- Keep any historical references that explain the rename
- Badge URLs will 404 until package is published to hex.pm (that's expected)
- The GIF recording scripts (task 009) may show old output - they'll be updated separately

## Files to Modify

- `README.md`
- `CLAUDE.md`
- `.claude/CODEBASE.md`
- `.claude/SUBAGENT.md` (if references exist)
- `CONTRIBUTING.md` (if references exist)
