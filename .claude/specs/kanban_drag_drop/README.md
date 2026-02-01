# Kanban Drag and Drop

## Overview

Implement mouse-based drag and drop to move tasks between Todo, In Progress, and Done columns in the 09_drag_drop example's kanban board view.

## Requirements

See `requirements.md` for EARS-formatted requirements.

## Design

See `design.md` for architecture and technical decisions.

## Related Tasks

Query with: `bd list --json | jq '.[] | select(.labels[]? | contains("kanban_drag_drop"))'`
