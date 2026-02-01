# Design

## Overview

Implement HTML5 Drag and Drop API for the kanban board example, allowing users to drag task cards between Todo, In Progress, and Done columns.

## Components

### Model State Extensions (`model.gleam`)
- `dragging_task_id: Option(String)` - Which task is being dragged
- `drop_target_column: Option(TaskStatus)` - Which column is being hovered

### Message Extensions (`msg.gleam`)
- `DragStart(String)` - Task drag started
- `DragEnd` - Task drag ended (cleanup)
- `DragOver(TaskStatus)` - Dragging over column
- `DragLeave` - Left drop zone
- `DropTask(TaskStatus)` - Task dropped on column

### Template Updates (`kanban_board.ghtml`)
- Task cards: `draggable="true"`, `@dragstart`, `@dragend`
- Columns: `@dragover`, `@dragleave`, `@drop`
- Conditional highlighting class

## Data Flow

```
User drags task card:
  1. dragstart → Store dragged task ID (DragStart)
  2. drag      → (Browser handles preview)

Dragging over column:
  3. dragenter → (Not needed)
  4. dragover  → Highlight drop zone (DragOver) + preventDefault
  5. dragleave → Remove highlight (DragLeave)

User drops:
  6. drop      → Change task status (DropTask)
  7. dragend   → Clean up drag state (DragEnd)
```

## Interfaces

### Event Decoders
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

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| HTML5 Drag and Drop | Native browser support | Custom mouse events, library |
| Model state for drag tracking | Lustre pattern | DataTransfer API only |
| `event.advanced` for preventDefault | Required for drop to work | Custom JS interop |
| No touch support initially | HTML5 DnD doesn't support touch | Touch events (future) |

## Error Handling

### Browser Compatibility
- HTML5 Drag and Drop well-supported in modern browsers
- Fallback: click-based move (existing functionality)

### Touch Devices
- HTML5 DnD doesn't work on touch
- Future enhancement: touch event handlers

### Performance
- Keyed lists already in place for efficient updates
- Minimal state changes during drag
