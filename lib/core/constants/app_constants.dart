class AppConstants {
  // API
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Storage
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // App Info
  static const String appName = 'Tornet Task';
  static const String appVersion = '1.0.0';
} 