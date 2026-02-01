# Editor Support

## Overview

Provide syntax highlighting and editor integration for `.ghtml` template files across major code editors, enabling a better developer experience when working with Lustre templates.

## Requirements

See `requirements.md` for EARS-formatted requirements.

## Design

See `design.md` for architecture and technical decisions.

## Related Tasks

Query with: `bd list --json | jq '.[] | select(.labels[]? | contains("editor_support"))'`
