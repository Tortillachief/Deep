# CLAUDE.md - Deep Flutter App Guidelines

## Build & Development Commands
- `flutter pub get` - Install dependencies
- `flutter pub run build_runner build` - Generate Drift database code
- `flutter run` - Run the app in debug mode
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run a specific test file
- `flutter analyze` - Run the Dart analyzer
- `flutter build apk` - Build Android APK
- `flutter clean` - Clean build files

## Code Style Guidelines
- **Imports**: Group Flutter imports first, then package imports, then relative imports
- **Formatting**: Use 2-space indentation and follow Flutter's style guide
- **Types**: Always use strong typing and avoid dynamic unless necessary
- **Naming**:
  - Classes: PascalCase
  - Variables/functions: camelCase
  - Constants: UPPER_CASE or kCamelCase
  - Files: snake_case.dart
- **Error Handling**: Use try/catch blocks with specific exception types
- **Database**: Use Drift ORM for database operations with generated code
- **State Management**: Provider pattern for app-wide state management

## Architecture Notes
- Flutter app with Material 3 design system
- SQLite database using Drift ORM with code generation
- Assets in assets folder include pre-populated SQLite database