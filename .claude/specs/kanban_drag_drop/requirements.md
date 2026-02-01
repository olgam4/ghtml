# Requirements

Requirements use EARS (Easy Approach to Requirements Syntax).

## Patterns
- **Event-driven**: WHEN <trigger> THE <system> SHALL <response>
- **State-driven**: WHILE <condition> THE <system> SHALL <response>
- **Complex**: WHILE <condition> WHEN <trigger> THE <system> SHALL <response>

---

## REQ-001: Draggable Task Cards

WHEN a user starts dragging a task card
THE system SHALL set the `dragging_task_id` in model state
AND the browser SHALL show the drag preview

**Acceptance Criteria:**
- [ ] Task cards have `draggable="true"` attribute
- [ ] `dragstart` event captures task ID
- [ ] `dragend` event clears drag state

---

## REQ-002: Drop Zone Detection

WHILE a task card is being dragged
WHEN the user drags over a column
THE system SHALL highlight the column as a valid drop target
AND track the `drop_target_column` in model state

**Acceptance Criteria:**
- [ ] `dragover` event with `preventDefault()` allows drop
- [ ] `dragleave` event removes highlight
- [ ] Visual feedback shows valid drop zone

---

## REQ-003: Task Status Change on Drop

WHEN a user drops a task card on a column
THE system SHALL change the task status to match the target column
AND clear all drag state

**Acceptance Criteria:**
- [ ] `drop` event triggers status change
- [ ] Task moves to new column visually
- [ ] Drag state fully cleared after drop

---

## REQ-004: Drop Zone Visual Feedback

WHILE dragging over a valid drop zone
THE column SHALL display visual highlighting
AND remove highlighting when drag leaves

**Acceptance Criteria:**
- [ ] Border or background change on dragover
- [ ] Highlight removed on dragleave
- [ ] Smooth visual transitions

---

## REQ-005: Same Column Drop Handling

WHEN a user drops a task in the same column it started in
THE system SHALL perform no status change
AND clear drag state normally

**Acceptance Criteria:**
- [ ] No unnecessary state updates
- [ ] Drag state cleared properly
