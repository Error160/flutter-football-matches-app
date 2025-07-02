import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const AdaptiveScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    // Since we only have matches now, just return the child directly
    return Scaffold(
      body: child
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOut),
    );
  }
} 