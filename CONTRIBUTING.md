# Contributing to IrisHub

## Development Principles

Keep the public API consistent across components. Prefer reusable primitives over duplicated UI logic. Preserve cleanup behavior for every event connection, tween, temporary instance, and long-lived callback.

## Pull Requests

Describe the user-facing change, include a focused example when the API changes, and update documentation for public methods or options.

## Code Style

Use Luau and avoid source comments beginning with `--`. Keep naming explicit and functions reasonably small. Avoid introducing dependencies when the same result can be achieved with existing IrisHub primitives.

## Testing

Run the smoke test inside Roblox Studio or a compatible runtime using `tests/SmokeTest.luau`. Verify component creation, state changes, theme operations and destruction before submitting UI changes.
