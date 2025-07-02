import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

/// Extension methods for easy navigation throughout the app
extension NavigationExtensions on BuildContext {
 

  
  void replaceWithMatches() => pushReplacement(AppRoutes.matches);
  
  // Utility methods
  bool get canPopRoute => canPop();
  
  void popRoute() {
      pop();
    
  }
  
  // Check current route
  
  bool get isMatchesRoute => GoRouterState.of(this).fullPath?.startsWith(AppRoutes.matches) ?? false;
  
  String? get currentRoute => GoRouterState.of(this).fullPath;
} 