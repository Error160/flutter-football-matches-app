class AppRoutes {
  // Route paths
  static const String matches = '/matches';

  // Route names
  static const String matchesName = 'matches';
  static const String matchDetailName = 'match-detail';

  // Route parameters
  static const String matchIdParam = 'matchId';

  // Helper methods for building routes with parameters
  static String getMatchDetailRoute(String matchId) {
    return '$matches/match/$matchId';
  }
} 