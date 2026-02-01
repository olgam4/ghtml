# Epic: Kanban Drag and Drop

## Goal
Implement mouse-based drag and drop to move tasks between Todo, In Progress, and Done columns in the 09_drag_drop example's kanban board view.

## Current State Analysis

### What Exists
- **Model** (`model.gleam:106`): `selected_task_id: Option(String)` tracks selection
- **Messages** (`msg.gleam:28`): `SetTaskStatus(String, TaskStatus)` can change task status
- **Kanban View** (`kanban_board.lustre`): 3 columns with task cards, click-to-select
- **Event Support**: Template generator supports `@on:eventname` for custom events like drag/drop

### What's Missing
1. `draggable="true"` attribute on task cards
2. Drag event handlers (`dragstart`, `dragover`, `drop`, `dragend`)
3. Model state to track which task is being dragged
4. Drop zone highlighting for visual feedback
5. Event decoders for drag events

## HTML5 Drag and Drop API Overview

```
User drags task card:
  1. dragstart → Store dragged task ID
  2. drag      → (Optional) Update drag position

Dragging over column:
  3. dragenter → Highlight drop zone
  4. dragover  → Allow drop (preventDefault required!)
  5. dragleave → Remove highlight

User drops:
  6. drop      → Change task status to target column
  7. dragend   → Clean up drag state
```

## Design Decisions

### State Tracking
Add to model:
- `dragging_task_id: Option(String)` - Which task is being dragged
- `drop_target_column: Option(TaskStatus)` - Which column is being hovered (for highlighting)

### Event Flow
| Event | Handler | Action |
|-------|---------|--------|
| `dragstart` | Task card | Store task ID in model |
| `dragover` | Column | Prevent default (allow drop), set highlight |
| `dragleave` | Column | Remove highlight |
| `drop` | Column | Change task status, clear drag state |
| `dragend` | Task card | Clear drag state (fallback cleanup) |

### Visual Feedback
- Dragged card: Browser default (semi-transparent copy)
- Drop target column: Blue border or background highlight
- Valid drop zones: All three columns

## Implementation Tasks

### Task 1: Add Drag State to Model
**Files:** `model.gleam`, `msg.gleam`

Add model fields and messages for drag state.

### Task 2: Add Draggable Task Cards
**Files:** `kanban_board.lustre`, `app.gleam`

Make task cards draggable with `dragstart` and `dragend` handlers.

### Task 3: Add Drop Zones to Columns
**Files:** `kanban_board.lustre`, `app.gleam`

Add `dragover`, `dragleave`, and `drop` handlers to columns.

### Task 4: Implement Drag Event Handlers
**Files:** `update.gleam`, `app.gleam`

Implement the update logic and event decoders.

### Task 5: Add Visual Drop Zone Feedback
**Files:** `kanban_board.lustre`

Highlight columns when dragging over them.

## File Change Summary

| File | Changes |
|------|---------|
| `model.gleam` | Add `dragging_task_id`, `drop_target_column` fields |
| `msg.gleam` | Add `DragStart`, `DragEnd`, `DragOver`, `DragLeave`, `DropTask` messages |
| `update.gleam` | Handle drag/drop messages |
| `kanban_board.lustre` | Add draggable attrs, drag/drop event handlers, drop zone styling |
| `app.gleam` | Add event decoders, pass handlers to kanban_board |

## Technical Notes

### Critical: `dragover` Must Prevent Default
By default, elements don't allow dropping. The `dragover` event handler MUST call `preventDefault()` or the drop won't work. In Lustre, this requires using `event.advanced` with `prevent_default: True`.

### Event Decoder Pattern
```gleam
fn decode_drag_start(task_id: String) -> decode.Decoder(Msg) {
  decode.success(msg.DragStart(task_id))
}

fn decode_drop(target_status: TaskStatus) -> decode.Decoder(Msg) {
  decode.success(msg.DropTask(target_status))
}
```

### Prevent Default Pattern
```gleam
// For dragover - must prevent default to allow drop
fn decode_drag_over(status: TaskStatus) -> decode.Decoder(event.Handler(Msg)) {
  decode.success(event.handler(msg.DragOver(status), True, False))
  // handler(msg, prevent_default, stop_propagation)
}
```

## Testing Strategy

1. **Manual Testing:**
   - Drag task from Todo to In Progress - should move
   - Drag task from In Progress to Done - should move
   - Drag task from Done back to Todo - should move
   - Drop outside columns - should cancel (no change)
   - Verify drop zone highlighting appears/disappears

2. **Edge Cases:**
   - Drag task and drop in same column - should be no-op
   - Rapid dragging multiple tasks
   - Dragging while filtered

## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Browser compatibility | HTML5 DnD is well-supported in modern browsers |
| Touch devices | HTML5 DnD doesn't work on touch; would need touch events (future enhancement) |
| `preventDefault` not working | Use `event.advanced` with handler pattern |
| Performance with many tasks | Use keyed lists (already in place) |
