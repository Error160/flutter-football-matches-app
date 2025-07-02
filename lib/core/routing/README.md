# 🚀 Adaptive Router System

A comprehensive, responsive routing solution for Flutter applications using `go_router` with adaptive navigation patterns.

## 📋 Features

### ✨ Adaptive Navigation
- **📱 Mobile**: Bottom navigation bar
- **🖥️ Desktop/Tablet**: Side navigation rail
- **📏 Responsive**: Automatically switches based on screen size (768px breakpoint)
- **🎨 Animated**: Smooth transitions using `flutter_animate`

### 🛣️ Smart Routing
- **🔗 Deep linking** support
- **📱 Type-safe** navigation
- **🔄 State preservation**
- **🚨 Error handling** with custom error page
- **🛡️ Route guards** (ready for future authentication)

### 🎯 Developer Experience
- **📦 Clean architecture** integration
- **🔧 Extension methods** for easy navigation
- **🌍 Localization** ready
- **📱 Screen utilities** integration

## 🏗️ Architecture

```
lib/core/routing/
├── app_router.dart           # Main router configuration
├── app_routes.dart           # Route constants and helpers
├── adaptive_scaffold.dart    # Responsive navigation UI
├── navigation_extensions.dart # Easy navigation methods
├── route_guard.dart          # Authentication & permission guards
├── routing_test_page.dart    # Test page for routing
└── router_exports.dart       # Barrel exports
```

## 🚀 Usage

### Basic Navigation

```dart
import 'package:tornet_task/core/routing/navigation_extensions.dart';

// Navigate to different pages
context.goToHome();
context.goToMatches();
context.goToMatchDetail('match-123');

// Push for modal navigation
context.pushToMatches();

// Replace current route
context.replaceWithHome();

// Go back with fallback
context.popRoute(); // Falls back to home if can't pop
```

### Route Checking

```dart
// Check current route
if (context.isHomeRoute) {
  // Do something for home
}

if (context.isMatchesRoute) {
  // Do something for matches
}

// Get current route path
String? currentPath = context.currentRoute;
```

### Static Navigation (from anywhere)

```dart
import 'package:tornet_task/core/routing/app_router.dart';

// Navigate from anywhere (e.g., BLoC, service)
AppRouter.goHome();
AppRouter.goToMatches();
AppRouter.goToMatchDetail('match-123');
AppRouter.goBack();

// Check navigation state
bool canGoBack = AppRouter.canGoBack();
String currentLocation = AppRouter.currentLocation;
```

## 📱 Responsive Behavior

### Mobile (< 768px)
- Bottom navigation bar
- Slide animations from bottom
- Compact navigation items

### Tablet/Desktop (≥ 768px)
- Side navigation rail
- Slide animations from left
- Extended labels on large screens (> 1200px)
- More spacious navigation items

## 🛣️ Route Structure

```dart
/ (home)                    # Home page
/matches                   # Matches page
/matches/match/:matchId    # Individual match details
```

## 🔧 Configuration

### Adding New Routes

1. **Add route constants** in `app_routes.dart`:
```dart
static const String profile = '/profile';
static const String profileName = 'profile';
```

2. **Add route definition** in `app_router.dart`:
```dart
GoRoute(
  path: AppRoutes.profile,
  name: AppRoutes.profileName,
  builder: (context, state) => const ProfilePage(),
),
```

3. **Add navigation methods** in `navigation_extensions.dart`:
```dart
void goToProfile() => go(AppRoutes.profile);
```

4. **Add navigation item** in `adaptive_scaffold.dart`:
```dart
BottomNavigationBarItem(
  icon: const Icon(Icons.person_outlined),
  activeIcon: const Icon(Icons.person),
  label: l10n.profile,
),
```

### Customizing Breakpoints

Modify the breakpoint in `adaptive_scaffold.dart`:

```dart
bool _isTabletOrDesktop(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth >= 768; // Change this value
}
```

### Adding Route Guards

Update `route_guard.dart` for authentication:

```dart
static String? redirectLogic(BuildContext context, GoRouterState state) {
  if (!isLoggedIn && state.fullPath != '/login') {
    return '/login';
  }
  return null;
}
```

Then add it to the router:

```dart
GoRouter(
  redirect: RouteGuard.redirectLogic,
  // ... other config
)
```

## 🎨 Customization

### Animations

Modify animations in `adaptive_scaffold.dart`:

```dart
.animate()
.slideY(begin: 1, duration: 300.ms, curve: Curves.easeOut)
```

### Navigation Colors

The navigation automatically uses your app's theme colors:
- `colorScheme.primary` for selected items
- `colorScheme.onSurface` with transparency for unselected items

### Screen Utility Integration

The router uses `flutter_screenutil` for responsive sizing:
- `24.r` for icon sizes
- `12.sp`, `14.sp` for font sizes
- `16.h` for spacing

## 🔍 Error Handling

The router includes a custom error page that:
- Shows a user-friendly error message
- Provides a "Go Home" button
- Maintains theme consistency
- Uses localized text

## 🌍 Localization

All navigation labels use localized strings:
- `l10n.home`
- `l10n.matches`
- Add more in `app_en.arb` and `app_ar.arb`

## 🧪 Testing

Use the `RoutingTestPage` to verify routing functionality:

```dart
// Add to your routes for testing
GoRoute(
  path: '/test',
  builder: (context, state) => const RoutingTestPage(),
),
```

## ⚡ Performance

- **Lazy loading**: Pages are only built when navigated to
- **State preservation**: Navigation state is maintained
- **Memory efficient**: Uses go_router's built-in optimizations
- **Smooth animations**: Hardware-accelerated transitions

## 🛡️ Future Features

- **Authentication guards**
- **Role-based permissions**
- **Deep link validation**
- **Analytics integration**
- **A/B testing support**

## 📚 Dependencies

- `go_router: ^14.6.1` - Core routing functionality
- `flutter_screenutil: ^5.9.3` - Responsive sizing
- `flutter_animate: ^4.5.0` - Smooth animations
- `flutter_localizations` - Internationalization

---

Built with ❤️ for clean, scalable Flutter applications. 