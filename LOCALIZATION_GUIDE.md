# 🌐 Localization Guide - Flutter Intl Setup

This guide explains how to use the **intl-based localization system** implemented in this Flutter project.

## 📁 Project Structure

```
lib/
├── l10n/                           # ARB files for translations
│   ├── app_en.arb                  # English translations (template)
│   └── app_ar.arb                  # Arabic translations
├── generated/                      # Generated localization files
│   └── l10n/
│       ├── app_localizations.dart   # Main localization class
│       ├── app_localizations_en.dart # English implementation
│       └── app_localizations_ar.dart # Arabic implementation
└── main.dart                       # App configuration
l10n.yaml                           # Localization configuration
```

## 🔧 Configuration Files

### 1. **l10n.yaml** (Root directory)
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/generated/l10n
synthetic-package: false
```

### 2. **pubspec.yaml** Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

## 📝 ARB Files (Application Resource Bundle)

### English Template (`lib/l10n/app_en.arb`)
```json
{
  "@@locale": "en",
  
  "home": "Home",
  "@home": {
    "description": "Home screen title"
  },
  
  "minutesAgo": "{count} minutes ago",
  "@minutesAgo": {
    "description": "Time indicator for activity that happened minutes ago",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

### Arabic Translation (`lib/l10n/app_ar.arb`)
```json
{
  "@@locale": "ar",
  
  "home": "الرئيسية",
  "@home": {
    "description": "Home screen title"
  },
  
  "minutesAgo": "منذ {count} دقائق",
  "@minutesAgo": {
    "description": "Time indicator for activity that happened minutes ago",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

## 🚀 Usage in Code

### 1. **Import Generated Localizations**
```dart
import 'package:flutter/material.dart';
import 'generated/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.home);
  }
}
```

### 2. **Using Placeholders**
```dart
// In your widget
Text(l10n.minutesAgo(5))  // English: "5 minutes ago"
                          // Arabic: "منذ 5 دقائق"
```

### 3. **App Configuration** (`main.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => 
          AppLocalizations.of(context)?.appTitle ?? 'App',
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      
      home: MyHomePage(),
    );
  }
}
```

## 🔄 Workflow

### 1. **Adding New Strings**
1. Add to `lib/l10n/app_en.arb` (template file)
2. Add translations to other ARB files
3. Run `flutter gen-l10n` to generate code
4. Use in your widgets

### 2. **Adding New Languages**
1. Create new ARB file: `lib/l10n/app_[locale].arb`
2. Copy structure from `app_en.arb`
3. Translate all strings
4. Add locale to `supportedLocales` in `main.dart`
5. Run `flutter gen-l10n`

### 3. **Generating Localizations**
```bash
# Generate localization files
flutter gen-l10n

# Or it's automatically generated when you run:
flutter run
flutter build
```

## 📊 Message Types

### 1. **Simple Messages**
```json
{
  "hello": "Hello",
  "@hello": {
    "description": "A greeting"
  }
}
```

### 2. **Messages with Placeholders**
```json
{
  "welcome": "Welcome, {name}!",
  "@welcome": {
    "description": "Welcome message with name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### 3. **Plural Messages**
```json
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

### 4. **Select Messages**
```json
{
  "gender": "{gender, select, male{He} female{She} other{They}}",
  "@gender": {
    "description": "Gender-based pronoun",
    "placeholders": {
      "gender": {
        "type": "String",
        "example": "male"
      }
    }
  }
}
```

## 🎨 Best Practices

### 1. **Naming Conventions**
- Use **camelCase** for keys: `userName`, `loginButton`
- Use descriptive names: `errorInvalidEmail` instead of `error1`
- Group related strings: `login_title`, `login_button`, `login_error`

### 2. **ARB File Organization**
```json
{
  "@@locale": "en",
  
  "// Authentication": "",
  "loginTitle": "Sign In",
  "loginButton": "Login",
  "loginError": "Invalid credentials",
  
  "// Home Screen": "",
  "homeTitle": "Home",
  "homeWelcome": "Welcome back!",
  
  "// Common": "",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete"
}
```

### 3. **Context Handling**
```dart
// ✅ Good - Handle null context
final l10n = AppLocalizations.of(context);
if (l10n == null) return Text('Loading...');

// ✅ Good - Use ! if you're sure context exists
final l10n = AppLocalizations.of(context)!;

// ✅ Good - Static method for validation
static String? validateEmail(String value, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return 'Email is required';
  
  return value.isEmpty ? l10n.emailRequired : null;
}
```

### 4. **Testing Localization**
```dart
// Test your widgets with different locales
Widget createWidgetForTesting({Locale? locale}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    home: YourWidget(),
  );
}
```

## 🔧 Troubleshooting

### 1. **Generation Issues**
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter gen-l10n
```

### 2. **Missing Translations**
- Check ARB file syntax (valid JSON)
- Ensure all placeholders are defined
- Verify `l10n.yaml` configuration

### 3. **Runtime Errors**
- Ensure `AppLocalizations.delegate` is in `localizationsDelegates`
- Check supported locales match your ARB files
- Verify context is available when calling `AppLocalizations.of(context)`

## 📱 Current Implementation

### Supported Languages
- **English (en)**: Primary language
- **Arabic (ar)**: RTL support included

### Available Strings
- App navigation (home, error, retry)
- Status indicators (active, inactive)
- Time formatting (just now, minutes/hours/days ago)
- Validation messages (email, password, required fields)
- Common actions (save, delete, cancel, etc.)

### Features Implemented
- ✅ Multi-language support
- ✅ Placeholder support for dynamic values
- ✅ RTL (Right-to-Left) support for Arabic
- ✅ Automatic locale detection
- ✅ Validation message localization
- ✅ Time formatting localization

## 🌍 Adding More Languages

### Example: Adding Spanish
1. Create `lib/l10n/app_es.arb`:
```json
{
  "@@locale": "es",
  "home": "Inicio",
  "error": "Error",
  "retry": "Reintentar"
}
```

2. Update `main.dart`:
```dart
supportedLocales: const [
  Locale('en'),
  Locale('ar'),
  Locale('es'), // Add Spanish
],
```

3. Generate:
```bash
flutter gen-l10n
```

## 🔗 Resources

- [Flutter Internationalization Guide](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl Package Documentation](https://pub.dev/packages/intl)
- [Flutter gen-l10n Command](https://docs.flutter.dev/development/accessibility-and-localization/internationalization#adding-your-own-localized-messages)

---

This localization system provides a robust foundation for multi-language support in your Flutter application! 🚀 