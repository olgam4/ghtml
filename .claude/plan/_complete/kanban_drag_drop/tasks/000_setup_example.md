# Task 0: Set Up Example 09

## Objective
Create example 09 by copying example 08 and configuring it for the drag and drop feature.

## Steps

### 1. Copy example directory
```bash
cp -r examples/08_complete examples/09_drag_drop
```

### 2. Update gleam.toml
Change project name and title:
```toml
name = "example_09_drag_drop"
...
title = "Task Manager - Drag and Drop"
```

### 3. Update README.md
Document the new drag and drop features this example will demonstrate.

### 4. Verify setup
```bash
cd examples/09_drag_drop
gleam build
```

## Acceptance Criteria
- [ ] Example 09 directory exists
- [ ] `gleam.toml` has correct name and title
- [ ] `gleam build` succeeds
- [ ] App runs with `gleam run -m lustre/dev start`
