# Task 5: Add Visual Drop Zone Feedback

## Objective
Highlight the column being hovered over during a drag operation to give the user clear visual feedback about where the task will be dropped.

## Prerequisites
- Task 1-4 completed (drag and drop is functional)

## Design

When a task is being dragged and hovers over a column:
- Add a colored border or background highlight to indicate it's a valid drop target
- Use colors consistent with the column's theme:
  - Todo: Gray → lighter gray or blue border
  - In Progress: Blue → brighter blue border
  - Done: Green → brighter green border

## Files to Modify

### 1. `examples/09_drag_drop/src/components/tasks/kanban_board.ghtml`

**Add drop_target_column parameter**:

```gleam
@import(gleam/int)
@import(gleam/list)
@import(gleam/option.{type Option, Some})
@import(model.{type Task, type TaskStatus, Todo, InProgress, Done})

@params(
  todo_tasks: List(Task),
  in_progress_tasks: List(Task),
  done_tasks: List(Task),
  drop_target_column: Option(TaskStatus),  // NEW
  on_task_click: fn(String) -> msg,
  on_drag_start: fn(String) -> msg,
  on_drag_end: fn() -> msg,
  on_drag_over: fn(TaskStatus) -> event.Handler(msg),
  on_drag_leave: fn() -> msg,
  on_drop: fn(TaskStatus) -> msg,
)
```

**Add conditional styling to Todo column**:

```html
{#if drop_target_column == Some(Todo)}
  <div
    class="bg-blue-100 dark:bg-blue-900/50 rounded-lg p-4 ring-2 ring-blue-500 ring-dashed transition-colors"
    @on:dragover={on_drag_over(Todo)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(Todo)}
  >
    <!-- column content -->
  </div>
{:else}
  <div
    class="bg-gray-100 dark:bg-gray-800 rounded-lg p-4 transition-colors"
    @on:dragover={on_drag_over(Todo)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(Todo)}
  >
    <!-- column content -->
  </div>
{/if}
```

**Same pattern for In Progress column**:

```html
{#if drop_target_column == Some(InProgress)}
  <div
    class="bg-blue-100 dark:bg-blue-800/50 rounded-lg p-4 ring-2 ring-blue-500 ring-dashed transition-colors"
    @on:dragover={on_drag_over(InProgress)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(InProgress)}
  >
    <!-- column content -->
  </div>
{:else}
  <div
    class="bg-blue-50 dark:bg-blue-900/30 rounded-lg p-4 transition-colors"
    @on:dragover={on_drag_over(InProgress)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(InProgress)}
  >
    <!-- column content -->
  </div>
{/if}
```

**Same pattern for Done column**:

```html
{#if drop_target_column == Some(Done)}
  <div
    class="bg-green-100 dark:bg-green-800/50 rounded-lg p-4 ring-2 ring-green-500 ring-dashed transition-colors"
    @on:dragover={on_drag_over(Done)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(Done)}
  >
    <!-- column content -->
  </div>
{:else}
  <div
    class="bg-green-50 dark:bg-green-900/30 rounded-lg p-4 transition-colors"
    @on:dragover={on_drag_over(Done)}
    @on:dragleave={on_drag_leave()}
    @on:drop={on_drop(Done)}
  >
    <!-- column content -->
  </div>
{/if}
```

### 2. `examples/09_drag_drop/src/app.gleam`

**Update kanban_board.render call** to pass `drop_target_column`:

```gleam
kanban_board.render(
  todo_tasks,
  in_progress_tasks,
  done_tasks,
  model.drop_target_column,  // NEW
  fn(id) { msg.SelectTask(id) },
  fn(id) { msg.DragStart(id) },
  fn() { msg.DragEnd },
  fn(status) { decode_drag_over(status) },
  fn() { msg.DragLeaveColumn },
  fn(status) { msg.DropOnColumn(status) },
)
```

## Alternative: Single Class with Dynamic Value

Instead of duplicating the entire column div with `{#if}`, use a helper function:

```gleam
// In app.gleam or a helper module
fn column_class(base: String, highlight: String, is_target: Bool) -> String {
  case is_target {
    True -> highlight
    False -> base
  }
}
```

But this requires passing computed classes, which may be simpler to handle inline.

## Visual Styling Notes

**Highlight styles used:**
- `ring-2 ring-blue-500 ring-dashed` - Dashed blue border
- Brighter background color
- `transition-colors` - Smooth transition when highlight appears/disappears

**Alternative highlight options:**
- `border-2 border-dashed border-blue-500` - Dashed border (different than ring)
- `scale-[1.02]` - Subtle scale up
- `shadow-lg` - Drop shadow

## Acceptance Criteria
- [ ] Column highlights when dragging over it
- [ ] Highlight disappears when leaving column
- [ ] Highlight disappears after drop
- [ ] Different columns have appropriate highlight colors
- [ ] Works in both light and dark mode
- [ ] Transition is smooth (not jarring)

## Testing
1. Start dragging a task
2. Drag over Todo column - should show blue dashed border
3. Drag to In Progress - Todo loses highlight, In Progress gains it
4. Drag to Done - In Progress loses highlight, Done gains it
5. Drop the task - highlight disappears
6. Test in dark mode - colors should still be visible
