# Task 009: Update Assets and GIF Scripts

## Description

Update GIF recording scripts to use the new CLI command and file extension. Optionally regenerate GIFs to show the new naming.

## Dependencies

- Task 008: Documentation

## Success Criteria

1. All GIF recording scripts use `gleam run -m ghtml`
2. All scripts reference `.ghtml` files
3. Scripts execute without errors
4. (Optional) GIFs regenerated with new naming

## Implementation Steps

### 1. Find GIF Recording Scripts

```bash
ls assets/gif-record/
```

### 2. Update Each Recording Script

For each script in `assets/gif-record/record-*.sh`:

**Update CLI commands:**
```bash
# Before
gleam run -m lustre_template_gen

# After
gleam run -m ghtml
```

**Update file references:**
```bash
# Before
*.lustre
greeting.lustre

# After
*.ghtml
greeting.ghtml
```

### 3. Update Any Template Files Used in GIFs

If there are template files in the assets directory for demos:

```bash
find assets -name "*.lustre" -exec bash -c 'mv "$0" "${0%.lustre}.ghtml"' {} \;
```

### 4. Test Scripts (Without Recording)

```bash
# Dry run each script to verify it works
bash -n assets/gif-record/record-hero.sh
```

### 5. (Optional) Regenerate GIFs

If the GIFs should show the new naming:

```bash
just gifs
```

Or for a single GIF:
```bash
just gif hero
```

## Verification Checklist

- [ ] `grep "lustre_template_gen" assets/gif-record/*.sh` returns no results
- [ ] `grep "\.lustre" assets/gif-record/*.sh` returns no results
- [ ] All recording scripts pass syntax check (`bash -n`)
- [ ] (Optional) GIFs regenerated with new branding

## Notes

- GIF regeneration requires: asciinema, agg, tmux, bat, ffmpeg (see assets/gif-record/README.md)
- If GIFs are not regenerated, they'll show old naming which may confuse users
- Consider whether logo update is needed (separate from this task)

## Files to Modify

- `assets/gif-record/record-*.sh` - all recording scripts
- Any `.lustre` files in assets/ (if any exist)
