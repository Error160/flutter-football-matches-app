# Clean Architecture Flutter Project Structure

This Flutter project follows Clean Architecture principles with a feature-first approach. The architecture is designed to be scalable, testable, and maintainable.

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # App-wide constants
│   ├── di/
│   │   ├── injection_container.dart    # Dependency injection setup
│   │   └── injection_container.config.dart  # Generated DI config
│   ├── errors/
│   │   └── failures.dart               # Error handling classes
│   ├── network/
│   │   └── network_info.dart           # Network connectivity check
│   ├── storage/
│   │   └── local_storage.dart          # Local storage abstraction
│   ├── theme/
│   │   └── app_theme.dart              # App theme configuration
│   ├── usecases/
│   │   └── usecase.dart                # Base use case classes
│   └── utils/
│       └── input_validators.dart        # Input validation utilities
├── features/
│   └── home/                           # Feature-based organization
│       ├── data/
│       │   ├── datasources/
│       │   │   └── home_remote_data_source.dart
│       │   ├── models/
│       │   │   └── home_item_model.dart
│       │   └── repositories/
│       │       └── home_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── home_item.dart
│       │   ├── repositories/
│       │   │   └── home_repository.dart
│       │   └── usecases/
│       │       └── get_home_items.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── home_bloc.dart
│           │   ├── home_event.dart
│           │   └── home_state.dart
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               └── home_item_card.dart
├── localization/
│   ├── app_localizations.dart          # Base localization class
│   └── app_localizations_en.dart       # English translations
└── main.dart                           # App entry point
```

## 🏗️ Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Business logic implementation

### 2. **Data Layer** (Data Access)
- **Data Sources**: Remote and local data sources
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete implementations of repository contracts

### 3. **Presentation Layer** (UI)
- **BLoC**: State management using BLoC pattern
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

### 4. **Core Layer** (Shared)
- **Constants**: App-wide constants
- **Errors**: Error handling
- **Network**: Network utilities
- **Storage**: Local storage abstraction
- **Theme**: App theming
- **Utils**: Utility functions

## 🔧 Key Dependencies

### State Management
- `flutter_bloc`: BLoC state management
- `equatable`: Object equality comparison

### Dependency Injection
- `get_it`: Service locator
- `injectable`: Code generation for DI

### Network & Data
- `dio`: HTTP client
- `http`: Basic HTTP client
- `dartz`: Functional programming (Either type)
- `shared_preferences`: Local storage

### UI & Animation
- `flutter_animate`: Animation library (as per user requirements)
- `flutter_screenutil`: Screen adaptation

### Localization
- `flutter_localizations`: Flutter localization support
- `intl`: Internationalization utilities

## 🚀 Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code:**
   ```bash
   flutter pub run build_runner build
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📱 Features

### Home Feature
- **Entity**: `HomeItem` - Core business object
- **Use Case**: `GetHomeItems` - Fetches home items
- **Repository**: `HomeRepository` - Data access contract
- **BLoC**: `HomeBloc` - State management
- **UI**: `HomePage` & `HomeItemCard` - User interface

## 🌐 Localization

The app supports multiple languages:
- All user-facing text is localized
- Easy to add new languages
- Follows Flutter's official localization approach

### Adding New Languages:
1. Create `app_localizations_[language].dart` in `lib/localization/`
2. Implement `AppLocalizations` abstract class
3. Update `supportedLocales` in `main.dart`

## 🎨 Theming

The app includes:
- Light and dark theme support
- Consistent color scheme
- Custom typography
- Material Design 3 components

## 📊 State Management

Using BLoC pattern:
- **Events**: User actions
- **States**: UI states
- **BLoC**: Business logic component
- **Repository**: Data access

## 🧪 Testing

Structure supports:
- Unit tests for use cases
- Widget tests for UI components
- Integration tests for features
- Mock implementations for repositories

## 🔄 Adding New Features

1. **Create feature folder** in `lib/features/`
2. **Domain layer**:
   - Create entities
   - Define repository interface
   - Implement use cases
3. **Data layer**:
   - Create models
   - Implement data sources
   - Implement repository
4. **Presentation layer**:
   - Create BLoC (events, states, bloc)
   - Create pages and widgets
5. **Register dependencies** in `injection_container.dart`

## 📝 Code Generation

The project uses code generation for:
- Dependency injection (`injectable`)
- JSON serialization (can be added with `json_annotation`)

Run code generation:
```bash
flutter pub run build_runner build
# or watch for changes
flutter pub run build_runner watch
```

## 🛠️ Development Guidelines

### Naming Conventions
- **Files**: snake_case
- **Classes**: PascalCase
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE

### Folder Structure
- Feature-first organization
- Clear separation of concerns
- Consistent naming patterns

### Code Quality
- Follow Flutter linting rules
- Use `const` constructors where possible
- Implement proper error handling
- Write meaningful tests

## 🔍 Error Handling

Robust error handling with:
- `Failure` classes for different error types
- `Either` type for success/failure results
- User-friendly error messages
- Retry mechanisms

## 📚 Resources

- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Flutter Localization Guide](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## 🤝 Contributing

1. Follow the established architecture patterns
2. Write tests for new features
3. Update documentation
4. Follow code style guidelines
5. Localize all user-facing text

---

This architecture provides a solid foundation for scalable Flutter applications with proper separation of concerns, testability, and maintainability. 