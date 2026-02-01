# Parallel Orchestrator

## Overview

Crash-resilient parallel agent orchestration system using a hybrid approach: `.specs/` for discoverable documentation and Beads for queryable execution state.

## Requirements

See `requirements.md` for EARS-formatted requirements.

## Design

See `design.md` for architecture and technical decisions.

## Research

See `research/` for investigation notes:
- `task_management_alternatives.md` - Comparison of task tracking approaches
- `spec_driven_beads_integration.md` - Hybrid spec + Beads design

## Related Tasks

Query with: `bd list --json | jq '.[] | select(.labels[]? | contains("parallel_orchestrator"))'`
