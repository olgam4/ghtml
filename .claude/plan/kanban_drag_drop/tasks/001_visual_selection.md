# Task 1: Add Drag State to Model and Messages

## Objective
Add the necessary model fields and message types to track drag and drop state.

## Files to Modify

### 1. `examples/09_drag_drop/src/model.gleam`

**Add fields to Model type** (around line 97-115):

```gleam
pub type Model {
  Model(
    tasks: List(Task),
    projects: List(Project),
    current_view: View,
    current_filter: Filter,
    sort_by: SortBy,
    search_query: String,
    sidebar_open: Bool,
    selected_task_id: Option(String),
    editing_task: Option(Task),
    dialog_open: DialogState,
    toast: Option(#(String, ToastType)),
    form: FormState,
    dark_mode: Bool,
    new_subtask_text: String,
    editing_subtask_id: Option(String),
    editing_subtask_text: String,
    // NEW: Drag and drop state
    dragging_task_id: Option(String),
    drop_target_column: Option(TaskStatus),
  )
}
```

**Update initial_model** (around line 130-149):

```gleam
pub fn initial_model() -> Model {
  Model(
    tasks: sample_tasks(),
    projects: sample_projects(),
    current_view: ListView,
    current_filter: All,
    sort_by: SortByCreated,
    search_query: "",
    sidebar_open: False,
    selected_task_id: option.None,
    editing_task: option.None,
    dialog_open: NoDialog,
    toast: option.None,
    form: empty_form(),
    dark_mode: False,
    new_subtask_text: "",
    editing_subtask_id: option.None,
    editing_subtask_text: "",
    // NEW
    dragging_task_id: option.None,
    drop_target_column: option.None,
  )
}
```

### 2. `examples/09_drag_drop/src/msg.gleam`

**Add drag/drop messages** (add after line 28, in Task actions section):

```gleam
  // Task actions
  SelectTask(String)
  DeselectTask
  CreateTask
  UpdateTask(String)
  DeleteTask(String)
  ToggleTaskStatus(String)
  SetTaskStatus(String, TaskStatus)

  // Drag and drop actions (NEW)
  DragStart(String)           // Task ID being dragged
  DragEnd                     // Drag cancelled or completed
  DragOverColumn(TaskStatus)  // Hovering over a column
  DragLeaveColumn             // Left a column
  DropOnColumn(TaskStatus)    // Dropped on a column
```

## Acceptance Criteria
- [ ] Model compiles with new fields
- [ ] Messages compile with new variants
- [ ] Initial model has `None` for both drag fields
- [ ] No runtime errors on app start

## Testing
1. Run `gleam build` in examples/09_drag_drop - should compile
2. Start app - should work as before (no visible changes yet)
