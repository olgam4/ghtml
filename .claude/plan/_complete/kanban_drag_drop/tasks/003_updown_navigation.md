# Task 3: Add Drop Zones to Columns

## Objective
Make the three kanban columns accept dropped tasks by handling `dragover`, `dragleave`, and `drop` events.

## Prerequisites
- Task 1 completed (drag state in model, messages defined)

## Critical Technical Note

**The `dragover` event MUST call `preventDefault()`** or the browser won't allow dropping. In Lustre, this requires using `event.advanced` instead of `event.on`.

## Files to Modify

### 1. `examples/09_drag_drop/src/components/tasks/kanban_board.ghtml`

**Update params** to accept drop zone handlers:

```gleam
@import(gleam/int)
@import(gleam/list)
@import(model.{type Task, type TaskStatus})
@import(lustre/event)  // Need for Handler type

@params(
  todo_tasks: List(Task),
  in_progress_tasks: List(Task),
  done_tasks: List(Task),
  on_task_click: fn(String) -> msg,
  on_drag_start: fn(String) -> msg,
  on_drag_end: fn() -> msg,
  // NEW: Drop zone handlers (using advanced handlers for dragover)
  on_drag_over: fn(TaskStatus) -> event.Handler(msg),
  on_drag_leave: fn() -> msg,
  on_drop: fn(TaskStatus) -> msg,
)
```

**Add drop handlers to Todo column** (the outer div, around line 13):

Before:
```html
<div class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4">
```

After:
```html
<div
  class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 transition-colors"
  @on:dragover={on_drag_over(model.Todo)}
  @on:dragleave={on_drag_leave()}
  @on:drop={on_drop(model.Todo)}
>
```

**Add drop handlers to In Progress column** (around line 34):
```html
<div
  class="bg-blue-50 dark:bg-blue-900/30 rounded-lg p-4 transition-colors"
  @on:dragover={on_drag_over(model.InProgress)}
  @on:dragleave={on_drag_leave()}
  @on:drop(model.InProgress)}
>
```

**Add drop handlers to Done column** (around line 55):
```html
<div
  class="bg-green-50 dark:bg-green-900/30 rounded-lg p-4 transition-colors"
  @on:dragover={on_drag_over(model.Done)}
  @on:dragleave={on_drag_leave()}
  @on:drop={on_drop(model.Done)}
>
```

### 2. `examples/09_drag_drop/src/app.gleam`

**Add decoder for dragover with preventDefault**:

```gleam
import lustre/event

/// Decoder for dragover that prevents default (required for drop to work)
fn decode_drag_over(status: model.TaskStatus) -> event.Handler(Msg) {
  // handler(message, prevent_default, stop_propagation)
  event.handler(msg.DragOverColumn(status), True, False)
}
```

**Update kanban_board.render call**:

```gleam
kanban_board.render(
  todo_tasks,
  in_progress_tasks,
  done_tasks,
  fn(id) { msg.SelectTask(id) },
  fn(id) { msg.DragStart(id) },
  fn() { msg.DragEnd },
  // NEW: Drop zone handlers
  fn(status) { decode_drag_over(status) },
  fn() { msg.DragLeaveColumn },
  fn(status) { msg.DropOnColumn(status) },
)
```

## Alternative: Use Gleam Code Directly in Template

If the template syntax doesn't support passing `event.Handler` directly, we may need to handle the dragover event differently:

**Option A:** Use FFI to add event listener with preventDefault
**Option B:** Create the handler in app.gleam and pass as decoder

The cleanest approach is Option B - pass a decoder function:

```gleam
// In app.gleam
fn drag_over_decoder(status: model.TaskStatus) -> decode.Decoder(Msg) {
  // Note: This won't prevent default!
  decode.success(msg.DragOverColumn(status))
}
```

**To actually prevent default**, we need to use `event.advanced`:

```gleam
// The column needs to use event.advanced directly
// This may require generating different code in the template
```

### Alternative Implementation in Pure Gleam (app.gleam)

If templates can't easily support `event.advanced`, we could render the kanban columns directly in `app.gleam` using Gleam:

```gleam
fn view_kanban_column(
  tasks: List(Task),
  status: TaskStatus,
  title: String,
  bg_class: String,
  on_task_click: fn(String) -> Msg,
  on_drag_start: fn(String) -> Msg,
) -> Element(Msg) {
  html.div(
    [
      attribute.class(bg_class <> " rounded-lg p-4 transition-colors"),
      // Use advanced handler for dragover to prevent default
      event.advanced("dragover", fn(_) {
        Ok(event.handler(msg.DragOverColumn(status), True, False))
      }),
      event.on("dragleave", decode.success(msg.DragLeaveColumn)),
      event.on("drop", decode.success(msg.DropOnColumn(status))),
    ],
    [
      // Column header
      view_column_header(title, list.length(tasks)),
      // Task cards
      html.div(
        [attribute.class("space-y-3")],
        list.map(tasks, fn(task) {
          view_task_card(task, on_task_click, on_drag_start)
        }),
      ),
    ],
  )
}
```

## Acceptance Criteria
- [ ] Dragging over a column doesn't show "not allowed" cursor
- [ ] `DragOverColumn` message fires when dragging over a column
- [ ] `DragLeaveColumn` message fires when leaving a column
- [ ] `DropOnColumn` message fires when dropping on a column
- [ ] Drop actually works (task moves - requires Task 4)

## Testing
1. Start dragging a task
2. Drag over a different column - cursor should allow drop (not the "no" symbol)
3. Messages should fire (verify in console)
4. Release over column - drop event should fire
