# Deep Conversation Cards

A Flutter application that displays conversation starter cards of various types.

## Features

- **Card Types**: Three different card types:
  - **Icebreakers**: Light, fun questions to start conversations
  - **Confessions**: Questions about personal experiences
  - **Deep**: Thought-provoking questions for meaningful discussions

- **Navigation**:
  - Swipe left/right or tap to move to the next card
  - Smooth animations between cards

- **Options Menu**:
  - Toggle shuffle mode to randomize card order
  - Enable/disable specific card types
  - Persistent settings that are saved between sessions

## Technical Details

- Uses **Drift** as an ORM for SQLite database
- Built with **Provider** for state management
- Implements **SharedPreferences** for storing user preferences
- Custom animated UI components
- Pre-populated SQLite database with conversation starter cards

## App Structure

- **lib/main.dart**: Main application entry point and UI
- **lib/game_card.dart**: Card UI component and configuration
- **lib/card_service.dart**: Business logic for card management
- **lib/settings_provider.dart**: User preferences management
- **lib/database/**: Database-related classes
  - **database_helper.dart**: Drift database setup
  - **cards.dart**: Card table definition

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter pub run build_runner build` to generate Drift database code
4. Run `flutter run` to start the app

## Customization

You can customize the cards by modifying the `assets/app_database.sqlite` file or adding your own card provider.
