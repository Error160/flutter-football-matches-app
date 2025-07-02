class WebSocketConfig {
  static const String development = 'development';
  static const String production = 'production';
  static const String demo = 'demo';
  static const String staging = 'staging';

  // Available WebSocket endpoints
  static const Map<String, String> endpoints = {
    // Demo/Mock endpoint (falls back to mock data)
    demo: 'wss://demo.tornetfooty.com',
    
    // Staging endpoint (real Torliga staging)
    staging: 'wss://mqtt.staging.torliga.com',
    
    // Development endpoint
    development: 'wss://mqtt.staging.torliga.com',
    
    // Production endpoint
    production: 'wss://mqtt.torliga.com',
    
    // Test endpoint
    'test': 'wss://echo.websocket.org',
  };

  static String getCurrentEndpoint(String environment) {
    return endpoints[environment] ?? endpoints[demo]!;
  }

  static WebSocketServiceConfig getConfig(String environment) {
    switch (environment) {
      case staging:
        return WebSocketServiceConfig(
          baseUrl: '${endpoints[staging]!}/app/4bae652d93c285868d11?protocol=7&client=js&version=4.3.1&flash=false',
          maxReconnectAttempts: 5,
          enableMockData: true, // Fallback to mock if staging fails
          connectionTimeout: Duration(seconds: 15),
          reconnectInterval: Duration(seconds: 5),
          isPusherProtocol: true,
          channel: 'thesports-football.matchs',
          eventName: 'score-event',
        );
      
      case development:
        return WebSocketServiceConfig(
          baseUrl: '${endpoints[development]!}/app/4bae652d93c285868d11?protocol=7&client=js&version=4.3.1&flash=false',
          maxReconnectAttempts: 5,
          enableMockData: true,
          connectionTimeout: Duration(seconds: 15),
          reconnectInterval: Duration(seconds: 3),
          isPusherProtocol: true,
          channel: 'thesports-football.matchs',
          eventName: 'score-event',
        );
      
      case production:
        return WebSocketServiceConfig(
          baseUrl: '${endpoints[production]!}/app/4bae652d93c285868d11?protocol=7&client=js&version=4.3.1&flash=false',
          maxReconnectAttempts: 3,
          enableMockData: false,
          connectionTimeout: Duration(seconds: 10),
          reconnectInterval: Duration(seconds: 5),
          isPusherProtocol: true,
          channel: 'thesports-football.matchs',
          eventName: 'score-event',
        );
      
      case demo:
      default:
        return WebSocketServiceConfig(
          baseUrl: endpoints[demo]!,
          maxReconnectAttempts: 1, // Fail fast for demo
          enableMockData: true,
          connectionTimeout: Duration(seconds: 5),
          reconnectInterval: Duration(seconds: 2),
          isPusherProtocol: false,
          channel: 'live-scores',
          eventName: 'live_score',
        );
    }
  }
}

class WebSocketServiceConfig {
  final String baseUrl;
  final int maxReconnectAttempts;
  final bool enableMockData;
  final Duration connectionTimeout;
  final Duration reconnectInterval;
  final Duration heartbeatInterval;
  final bool isPusherProtocol;
  final String channel;
  final String eventName;

  const WebSocketServiceConfig({
    required this.baseUrl,
    required this.maxReconnectAttempts,
    required this.enableMockData,
    required this.connectionTimeout,
    required this.reconnectInterval,
    this.heartbeatInterval = const Duration(seconds: 30),
    this.isPusherProtocol = false,
    this.channel = 'live-scores',
    this.eventName = 'live_score',
  });
} 