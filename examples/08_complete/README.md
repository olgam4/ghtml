# Task Manager - Complete Example

A production-quality task management application demonstrating all Lustre template features in a realistic context.

## Features

### Core Functionality
- Create, read, update, delete tasks
- Task categories/projects
- Priority levels (High, Medium, Low, None)
- Due dates with overdue indicators
- Task status workflow (Todo -> In Progress -> Done)
- Subtasks/checklist items
- Search and filter
- Bulk actions (complete all, delete completed)

### UI/UX
- Responsive sidebar navigation (collapsible on mobile)
- Kanban board view option
- List view with sorting
- Empty states with helpful prompts
- Loading states
- Confirmation dialogs for destructive actions
- Toast notifications for feedback

### Data Persistence
- LocalStorage for task data
- Import/export as JSON

## Template Features Demonstrated

This example showcases all Lustre template features:

### Control Flow
- `{#if}...{:else}...{/if}` - Conditional rendering for selected states, empty states
- `{#each}...{/each}` - Iterating over tasks, projects, subtasks
- `{#case}...{/case}` - Pattern matching on task status, priority, toast type

### Attributes
- Static attributes: `class="..."`
- Dynamic attributes: `value={form.title}`
- Boolean attributes: `checked`, `open`, `required`
- Event handlers: `@click`, `@sl-input`, `@sl-change`

### Web Components (Shoelace)
- `sl-input`, `sl-textarea` - Form inputs
- `sl-button` - Styled buttons
- `sl-select`, `sl-option` - Dropdowns
- `sl-dialog` - Modal dialogs
- `sl-dropdown`, `sl-menu` - Menus
- `sl-spinner` - Loading indicator

### Styling (Tailwind CSS)
- Responsive design with breakpoint modifiers (`sm:`, `md:`, `lg:`)
- Utility classes for layout, spacing, colors
- State variants (`hover:`, `focus:`)
- Custom animations

## Architecture

```
08_complete/
├── gleam.toml              # Project configuration
├── README.md               # This file
├── assets/
│   └── styles.css          # Custom styles
└── src/
    ├── app.gleam           # Main entry point
    ├── model.gleam         # Application state types
    ├── msg.gleam           # Message types
    ├── update.gleam        # State update logic
    ├── storage.gleam       # LocalStorage persistence
    ├── ffi.mjs             # JavaScript FFI
    └── components/
        ├── layout/         # Layout components
        ├── tasks/          # Task-related components
        ├── filters/        # Filter components
        ├── dialogs/        # Dialog components
        └── common/         # Shared components
```

## Running the Example

1. Generate Gleam files from templates:
   ```bash
   just run examples/08_complete
   ```

2. Install dependencies:
   ```bash
   cd examples/08_complete
   gleam deps download
   ```

3. Start the development server:
   ```bash
   gleam run -m lustre/dev start
   ```

4. Open http://localhost:1234 in your browser

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `n` | New task |
| `Escape` | Close dialog/deselect |
| `/` | Focus search |

## Responsive Breakpoints

- **Mobile** (< 640px): Single column, bottom nav, slide-out sidebar
- **Tablet** (640-1023px): Two columns, collapsible sidebar
- **Desktop** (>= 1024px): Full layout with permanent sidebar

## Component Breakdown

### Layout Components
- `app_shell.lustre` - Main layout wrapper
- `sidebar.lustre` - Navigation sidebar with projects
- `header.lustre` - Top header with search and controls
- `mobile_nav.lustre` - Bottom navigation for mobile

### Task Components
- `task_card.lustre` - Individual task card
- `task_list.lustre` - List of tasks
- `task_detail.lustre` - Full task view/edit
- `task_form.lustre` - Create/edit form
- `subtask_item.lustre` - Checklist item
- `kanban_board.lustre` - Kanban view

### Filter Components
- `filter_bar.lustre` - Filter controls
- `search_input.lustre` - Search box
- `sort_dropdown.lustre` - Sort options

### Dialog Components
- `confirm_dialog.lustre` - Confirmation modal
- `task_dialog.lustre` - Add/edit task modal
- `export_dialog.lustre` - Export options

### Common Components
- `button.lustre` - Button variants
- `badge.lustre` - Status/priority badges
- `empty_state.lustre` - Empty content placeholder
- `toast.lustre` - Notification toast
- `loading.lustre` - Loading spinner
