# Task 4: Implement Drag/Drop Update Logic

## Objective
Handle drag and drop messages in the update function to actually move tasks between columns.

## Prerequisites
- Task 1 (model/messages)
- Task 2 (draggable cards)
- Task 3 (drop zones)

## Files to Modify

### `examples/09_drag_drop/src/update.gleam`

**Add handlers for drag/drop messages** (add cases in the main `update` function, around line 93):

```gleam
    // Drag and drop actions
    msg.DragStart(task_id) ->
      Model(..model, dragging_task_id: Some(task_id))

    msg.DragEnd ->
      Model(
        ..model,
        dragging_task_id: None,
        drop_target_column: None,
      )

    msg.DragOverColumn(status) ->
      Model(..model, drop_target_column: Some(status))

    msg.DragLeaveColumn ->
      Model(..model, drop_target_column: None)

    msg.DropOnColumn(target_status) -> {
      case model.dragging_task_id {
        None -> model  // Nothing being dragged
        Some(task_id) -> {
          // Find the task and check if it's actually changing status
          case find_task(model.tasks, task_id) {
            None -> model
            Some(task) -> {
              case task.status == target_status {
                True ->
                  // Dropped in same column, just clear drag state
                  Model(
                    ..model,
                    dragging_task_id: None,
                    drop_target_column: None,
                  )
                False -> {
                  // Move task to new column
                  let updated_tasks =
                    list.map(model.tasks, fn(t) {
                      case t.id == task_id {
                        True -> Task(..t, status: target_status)
                        False -> t
                      }
                    })
                  Model(
                    ..model,
                    tasks: updated_tasks,
                    dragging_task_id: None,
                    drop_target_column: None,
                    // Optionally show toast
                    // toast: Some(#("Task moved to " <> status_name(target_status), model.Info)),
                  )
                }
              }
            }
          }
        }
      }
    }
```

**Optional: Add status name helper** for toast messages:

```gleam
fn status_name(status: model.TaskStatus) -> String {
  case status {
    Todo -> "Todo"
    InProgress -> "In Progress"
    Done -> "Done"
  }
}
```

## Logic Flow

```
DragStart(task_id):
  └─► Set dragging_task_id = Some(task_id)

DragOverColumn(status):
  └─► Set drop_target_column = Some(status)
      (Used for visual highlighting in Task 5)

DragLeaveColumn:
  └─► Set drop_target_column = None

DropOnColumn(target_status):
  ├─► If no task being dragged → do nothing
  ├─► If dropped in same column → clear drag state
  └─► If dropped in different column:
      ├─► Update task's status
      └─► Clear drag state

DragEnd:
  └─► Clear all drag state (fallback cleanup)
```

## Edge Cases Handled

1. **Drop on same column**: No status change, just clears drag state
2. **No task being dragged**: DropOnColumn is a no-op
3. **Task not found**: Safety check, returns unchanged model
4. **Drag cancelled** (Escape or drop outside): DragEnd clears state

## Acceptance Criteria
- [ ] Dragging task from Todo and dropping on In Progress moves it
- [ ] Dragging task from In Progress and dropping on Done moves it
- [ ] Dragging task from Done and dropping on Todo moves it
- [ ] Dropping task on same column doesn't change anything
- [ ] Pressing Escape during drag cancels (via DragEnd)
- [ ] Drag state is always cleared after drop

## Testing
1. Drag a task from Todo to In Progress - task should appear in In Progress column
2. Drag same task to Done - task should appear in Done column
3. Drag task back to Todo - should work
4. Drag task within same column - should stay in place
5. Start dragging, press Escape - should cancel
6. Drag task outside all columns, release - should cancel
