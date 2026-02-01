# Multi-Target Architecture

## Overview

Establish a pluggable target architecture for ghtml that separates target-agnostic template processing from target-specific code generation. This enables the same `.ghtml` template to generate different output formats (Lustre Element, StringTree, String) via compile-time target selection.

## Requirements

See `requirements.md` for EARS-formatted requirements.

## Design

See `design.md` for architecture and technical decisions.

## Related Tasks

Query with: `bd list --json | jq '.[] | select(.labels[]? | contains("multi_target_architecture"))'`
