# Task 2: Make Task Cards Draggable

## Objective
Add `draggable="true"` attribute and drag event handlers to task cards in the kanban board.

## Prerequisites
- Task 1 completed (drag state in model, messages defined)

## Files to Modify

### 1. `examples/09_drag_drop/src/components/tasks/kanban_board.lustre`

**Update params** to accept drag handlers:

```gleam
@import(gleam/int)
@import(gleam/list)
@import(model.{type Task})

@params(
  todo_tasks: List(Task),
  in_progress_tasks: List(Task),
  done_tasks: List(Task),
  on_task_click: fn(String) -> msg,
  // NEW: Drag handlers
  on_drag_start: fn(String) -> msg,
  on_drag_end: fn() -> msg,
)
```

**Update task cards** in each column to be draggable:

Before (Todo column, lines 21-29):
```html
<div
  class="bg-white dark:bg-gray-700 p-3 rounded-lg shadow-sm cursor-pointer hover:shadow-md transition-shadow"
  @click={on_task_click(task.id)}
>
```

After:
```html
<div
  draggable="true"
  class="bg-white dark:bg-gray-700 p-3 rounded-lg shadow-sm cursor-grab hover:shadow-md transition-shadow active:cursor-grabbing"
  @click={on_task_click(task.id)}
  @on:dragstart={on_drag_start(task.id)}
  @on:dragend={on_drag_end()}
>
```

**Apply to all three columns** (Todo, In Progress, Done).

Note: Changed `cursor-pointer` to `cursor-grab` and added `active:cursor-grabbing` for better UX.

### 2. `examples/09_drag_drop/src/app.gleam`

**Update kanban_board.render call** (around line 171):

Before:
```gleam
kanban_board.render(todo_tasks, in_progress_tasks, done_tasks, fn(id) {
  msg.SelectTask(id)
})
```

After:
```gleam
kanban_board.render(
  todo_tasks,
  in_progress_tasks,
  done_tasks,
  fn(id) { msg.SelectTask(id) },
  // NEW: Drag handlers
  fn(id) { msg.DragStart(id) },
  fn() { msg.DragEnd },
)
```

## Generated Code Preview

The template will generate something like:
```gleam
html.div([
  attribute.attribute("draggable", "true"),
  attribute.class("bg-white dark:bg-gray-700 ..."),
  event.on_click(on_task_click(task.id)),
  event.on("dragstart", on_drag_start(task.id)),
  event.on("dragend", on_drag_end()),
], [...])
```

## Acceptance Criteria
- [ ] Task cards show grab cursor on hover
- [ ] Task cards can be picked up and dragged (browser shows ghost image)
- [ ] `DragStart` message fires when drag begins (verify via console/toast)
- [ ] `DragEnd` message fires when drag ends
- [ ] Clicking still selects task (doesn't conflict with drag)

## Testing
1. Hover over a task card - cursor should be grab hand
2. Click and drag a task - should see semi-transparent copy following mouse
3. Release - card should snap back (drop not implemented yet)
4. Click without dragging - should still select task
