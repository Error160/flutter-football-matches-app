class ApiConstants {
  // Base URLs
  static const String stagingBaseUrl = 'https://staging.torliga.com/api/v1';
  static const String productionBaseUrl = 'https://torliga.com/api/v1';
  
  // Authentication
  static const String bearerToken = '15819|rX7ELUR9o4zNtSfCvAygVYvhTeiPGGBn18gNXotU3d8b99d2';
  
  // Environment
  static const String currentEnvironment = 'staging'; // Change to 'production' for live
  
  // Current base URL based on environment
  static String get baseUrl => 
      currentEnvironment == 'production' ? productionBaseUrl : stagingBaseUrl;
  
  // Endpoints
  static const String todayMatches = '/home/todayMatches';
  static const String yesterdayMatches = '/home/yesterdayMatches';
  static const String tomorrowMatches = '/home/tomorrowMatches';
  
  // Full URLs
  static String get todayMatchesUrl => '$baseUrl$todayMatches';
  static String get yesterdayMatchesUrl => '$baseUrl$yesterdayMatches';
  static String get tomorrowMatchesUrl => '$baseUrl$tomorrowMatches';
  
  // Headers
  static Map<String, String> get headers => {
    'Authorization': 'Bearer $bearerToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // WebSocket Configuration
  static const String wsEnvironment = 'staging'; // staging, development, production, demo
} 