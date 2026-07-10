# Contributing to ProfileForge

Thank you for your interest in contributing! This guide will help you get started.

## Code of Conduct

By participating, you agree to uphold a respectful and inclusive environment. Harassment, discrimination, or abusive behavior will not be tolerated.

## Getting Started

### Prerequisites

- Flutter SDK 3.44+
- Python 3.11+
- Git

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/profileforge.git
   cd profileforge
   ```
3. Set up the frontend:
   ```bash
   flutter pub get
   flutter gen-l10n
   ```
4. Set up the backend:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt -r requirements-dev.txt
   cp .env.example .env
   # Edit .env with your configuration
   ```

## Development Workflow

### Before You Code

- Check existing issues or create a new one
- Discuss major changes in the issue first
- Keep changes focused and atomic

### Coding Standards

#### Flutter/Dart

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Run `flutter analyze` before committing
- Run `flutter test` to ensure tests pass
- Use `flutter format .` for consistent formatting

#### Python Backend

- Follow [PEP 8](https://pep8.org/) (enforced by Ruff/Black)
- Run `ruff check backend/` and `black --check backend/`
- Run `pytest backend/` for tests
- Type hints required for public functions

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): short description

Longer explanation if needed

Fixes #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Pull Request Process

1. Ensure all CI checks pass (`flutter analyze`, `flutter test`, `pytest`, `ruff`, `black`)
2. Update documentation if needed
3. Add tests for new features
4. Request review from maintainers
5. Address review feedback
6. Squash commits if requested

## Architecture Guidelines

### State Management (Riverpod)

- Use feature-based provider files: `providers/<feature>_providers.dart`
- Export via `providers/providers.dart` barrel
- Prefer `NotifierProvider`/`AsyncNotifierProvider` over `StateNotifierProvider`
- Use `Result<T>` pattern for async operations (see `core/errors/result.dart`)

### Error Handling

- Use `ErrorBoundary` widget for UI error isolation
- Return `Future<Result<T>>` from async providers/services
- Handle `AsyncValue.error` explicitly in widgets

### Database (Drift)

- Add migrations for schema changes in `db/migrations/`
- Use parameterized queries; never interpolate SQL
- Add indexes for foreign keys and frequently queried columns

### i18n

- All user-facing strings go in `lib/l10n/app_en.arb`
- Run `flutter gen-l10n` after adding strings
- Use `AppLocalizations.of(context)!.key` in widgets

## Testing

### Unit Tests

- Test pure logic in providers, services, utilities
- Mock dependencies with `mocktail`
- Aim for >80% coverage on new code

### Widget Tests

- Test key user interactions and state transitions
- Use `pumpWidget` with `ProviderScope`
- Test error states and loading states

### Integration Tests

- Add to `integration_test/` for critical flows
- Run on device/emulator

## Reporting Bugs

Use the GitHub issue template. Include:
- Flutter version (`flutter --version`)
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device/OS info

## Feature Requests

Open an issue with:
- Clear description of the feature
- Use cases / user stories
- Mockups or designs if UI-related
- Any technical considerations

## Questions?

Open a discussion or ask in an issue. Maintainers will respond as soon as possible.

---

Thank you for contributing to ProfileForge!