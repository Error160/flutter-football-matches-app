import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'websocket_config.dart';

abstract class WebSocketService {
  Stream<Map<String, dynamic>> get dataStream;
  Future<void> connect();
  Future<void> disconnect();
  bool get isConnected;
  void subscribe(String channel);
  void unsubscribe(String channel);
}

class WebSocketServiceImpl implements WebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;
  final Set<String> _subscribedChannels = {};
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _mockDataTimer;
  
  final WebSocketServiceConfig config;
  int _reconnectAttempts = 0;

  WebSocketServiceImpl({
    WebSocketServiceConfig? config,
  }) : config = config ?? WebSocketConfig.getConfig(WebSocketConfig.demo);

  @override
  Stream<Map<String, dynamic>> get dataStream => 
      _controller?.stream ?? const Stream.empty();

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _controller?.close();
      _controller = StreamController<Map<String, dynamic>>.broadcast();
      
      final wsUrl = config.isPusherProtocol ? config.baseUrl : '${config.baseUrl}/ws';
      debugPrint('Attempting WebSocket connection to: $wsUrl');
      debugPrint('Protocol: ${config.isPusherProtocol ? "Pusher" : "Standard"}');
      
      await _attemptConnection(wsUrl);
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
      _handleConnectionFailure();
    }
  }

  Future<void> _attemptConnection(String wsUrl) async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['echo-protocol'],
      );
      
      final connectionCompleter = Completer<void>();
      Timer? timeoutTimer;
      
      final subscription = _channel!.stream.listen(
        (message) {
          if (!connectionCompleter.isCompleted) {
            connectionCompleter.complete();
          }
          _handleMessage(message);
        },
        onError: (error) {
          if (!connectionCompleter.isCompleted) {
            connectionCompleter.completeError(error);
          }
          _handleError(error);
        },
        onDone: () {
          if (!connectionCompleter.isCompleted) {
            connectionCompleter.completeError('Connection closed unexpectedly');
          }
          _handleDisconnection();
        },
      );

      timeoutTimer = Timer(config.connectionTimeout, () {
        if (!connectionCompleter.isCompleted) {
          connectionCompleter.completeError('Connection timeout');
          subscription.cancel();
          _channel?.sink.close();
        }
      });

      await connectionCompleter.future;
      timeoutTimer.cancel();

      _isConnected = true;
      _reconnectAttempts = 0;
      _startHeartbeat();
      
      debugPrint('WebSocket connected successfully');
      
      if (config.isPusherProtocol) {
        _sendPusherSubscription(config.channel);
      } else {
        for (final channel in _subscribedChannels) {
          _sendSubscription(channel);
        }
      }
    } catch (e) {
      debugPrint('WebSocket connection attempt failed: $e');
      rethrow;
    }
  }

  void _handleConnectionFailure() {
    _isConnected = false;
    
    if (config.enableMockData && _reconnectAttempts >= config.maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached. Starting mock data service...');
      _startMockDataService();
    } else {
      _scheduleReconnect();
    }
  }

  void _startMockDataService() {
    debugPrint('🔄 Starting mock WebSocket data service for demo purposes');
    _isConnected = true; // Consider mock as connected
    
    _mockDataTimer?.cancel();
    _mockDataTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _generateMockMatchUpdate();
    });
    
    // Send initial mock data after a delay
    Timer(const Duration(seconds: 3), () {
      _generateMockMatchUpdate();
    });
  }

  void _generateMockMatchUpdate() {
    final mockMatchId = 'MOCK_${DateTime.now().millisecondsSinceEpoch % 1000}';
    final homeScore = DateTime.now().second % 4;
    final awayScore = DateTime.now().second % 3;
    final minute = 15 + (DateTime.now().minute % 75);
    
    final mockData = {
      'type': 'live_score',
      'channel': 'live-scores',
      'data': [
        mockMatchId,
        null,
        [homeScore], // Home score
        [awayScore], // Away score
        2, // Status: First half
        minute, // Minute
      ],
    };
    
    _controller?.add(mockData);
    debugPrint('🎭 MOCK DATA: Match $mockMatchId - $homeScore:$awayScore (${minute}min)');
  }

  @override
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _mockDataTimer?.cancel();
    _isConnected = false;
    
    try {
      await _channel?.sink.close();
    } catch (e) {
      debugPrint('Error closing WebSocket: $e');
    }
    
    await _controller?.close();
    _channel = null;
    _controller = null;
    
    debugPrint('WebSocket service disconnected');
  }

  @override
  void subscribe(String channel) {
    _subscribedChannels.add(channel);
    if (_isConnected) {
      _sendSubscription(channel);
    }
    debugPrint('📡 Subscribed to channel: $channel');
  }

  @override
  void unsubscribe(String channel) {
    _subscribedChannels.remove(channel);
    if (_isConnected) {
      _sendUnsubscription(channel);
    }
    debugPrint('📡 Unsubscribed from channel: $channel');
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString());
      if (data is Map<String, dynamic>) {
        if (config.isPusherProtocol) {
          _handlePusherMessage(data);
        } else {
          _controller?.add(data);
          debugPrint('📨 Received message: ${data['type']}');
        }
      }
    } catch (e) {
      debugPrint('Error parsing WebSocket message: $e');
    }
  }

  void _handlePusherMessage(Map<String, dynamic> data) {
    final event = data['event'] as String?;
    
    if (event == config.eventName) {
      // Stop mock data when receiving real Pusher data
      _mockDataTimer?.cancel();
      
      // Handle score-event
      final messageData = data['data'];
      debugPrint('🔍 Raw Pusher data type: ${messageData.runtimeType}');
      debugPrint('🔍 Raw Pusher data: $messageData');
      debugPrint('🔍 Raw Pusher data length: ${messageData is List ? messageData.length : 'N/A'}');
      
      try {
        dynamic scoreData;
        
        if (messageData is String) {
          scoreData = jsonDecode(messageData);
        } else {
          scoreData = messageData;
        }
        
        debugPrint('🔍 Parsed score data type: ${scoreData.runtimeType}');
        debugPrint('🔍 Parsed score data: $scoreData');
        
        if (scoreData is List && scoreData.isNotEmpty) {
          // Check if this is a direct match update array (6 elements: id, status, home, away, timestamp, reserved)
          if (scoreData.length >= 5 && _isDirectMatchUpdate(scoreData)) {
            final transformedData = _transformPusherScoreData(scoreData);
            _controller?.add(transformedData);
            debugPrint('📊 Pusher direct match update: ${scoreData[0]}');
          } else {
            // Handle array of match updates (nested structure)
            bool foundValidUpdate = false;
            for (final matchUpdate in scoreData) {
              if (matchUpdate is List && matchUpdate.length >= 5) {
                final transformedData = _transformPusherScoreData(matchUpdate);
                _controller?.add(transformedData);
                debugPrint('📊 Pusher nested match update: ${matchUpdate[0]}');
                foundValidUpdate = true;
              }
            }
            
            if (!foundValidUpdate) {
              debugPrint('⚠️ No valid match updates found in array: $scoreData');
              // Try to extract meaningful data from the array
              _tryParseAlternativeFormat(scoreData);
            }
          }
        } else {
          debugPrint('⚠️ Unexpected score data format: $scoreData');
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Error parsing Pusher score data: $e');
        debugPrint('📍 Stack trace: $stackTrace');
        debugPrint('📍 Original data: $messageData');
      }
    } else if (event == 'pusher:connection_established') {
      debugPrint('🔗 Pusher connection established');
    } else if (event == 'pusher_internal:subscription_succeeded') {
      debugPrint('✅ Pusher channel subscription successful');
    } else {
      debugPrint('📨 Pusher event: $event');
    }
  }

  Map<String, dynamic> _transformPusherScoreData(List<dynamic> scoreArray) {
    try {
      // Transform Pusher format to our expected format
      // scoreArray format: [matchId, status, homeData, awayData, kickoffTimestamp, reserved]
      debugPrint('🔄 Transforming score array: $scoreArray');
      
      if (scoreArray.length < 5) {
        debugPrint('⚠️ Score array too short: ${scoreArray.length} elements');
        throw Exception('Invalid score array length: ${scoreArray.length}');
      }
      
      final matchId = scoreArray[0]?.toString() ?? 'unknown';
      final status = _parseIntSafely(scoreArray[1]) ?? 1;
      final homeData = _parseListSafely(scoreArray[2]) ?? [0];
      final awayData = _parseListSafely(scoreArray[3]) ?? [0];
      final kickoffTimestamp = _parseIntSafely(scoreArray[4]) ?? 0;
      
      final minute = _calculateMinute(kickoffTimestamp);
      
      final transformedData = {
        'type': 'live_score',
        'channel': config.channel,
        'data': [
          matchId,        // Match ID
          null,           // Reserved
          homeData,       // Home team data
          awayData,       // Away team data
          status,         // Status
          minute,         // Calculated minute
        ],
      };
      
      debugPrint('✅ Transformed data: $transformedData');
      return transformedData;
    } catch (e) {
      debugPrint('❌ Error transforming Pusher score data: $e');
      debugPrint('📍 Score array: $scoreArray');
      rethrow;
    }
  }
  
  int? _parseIntSafely(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }
  
  List<dynamic>? _parseListSafely(dynamic value) {
    if (value is List) return value;
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        return decoded is List ? decoded : null;
      } catch (e) {
        debugPrint('Failed to parse list from string: $value');
        return null;
      }
    }
    return null;
  }

  bool _isDirectMatchUpdate(List<dynamic> data) {
    // Check if this looks like a direct match update
    // Expected format: [matchId, status, homeData, awayData, timestamp, reserved]
    if (data.length < 5) return false;
    
    // First element should be a string (match ID) or could be parsed as string
    final matchId = data[0];
    if (matchId == null) return false;
    
    // Second element should be a number (status)
    final status = _parseIntSafely(data[1]);
    if (status == null) return false;
    
    // Third and fourth elements should be arrays (team data) or parseable as arrays
    final homeData = _parseListSafely(data[2]);
    final awayData = _parseListSafely(data[3]);
    if (homeData == null && awayData == null) return false;
    
    // Fifth element should be a timestamp (number)
    final timestamp = _parseIntSafely(data[4]);
    if (timestamp == null) return false;
    
    debugPrint('✅ Detected direct match update format');
    return true;
  }

  void _tryParseAlternativeFormat(List<dynamic> data) {
    debugPrint('🔍 Trying alternative parsing for: $data');
    
    // Try to find meaningful patterns in the data
    if (data.length >= 2) {
      // Look for potential match ID and status pairs
      for (int i = 0; i < data.length - 1; i += 2) {
        final potentialId = data[i]?.toString();
        final potentialStatus = _parseIntSafely(data[i + 1]);
        
        if (potentialId != null && 
            potentialId.isNotEmpty && 
            potentialStatus != null &&
            potentialStatus >= 0 && 
            potentialStatus <= 13) {
          
          debugPrint('🎯 Found potential match: ID=$potentialId, Status=$potentialStatus');
          
          // Create a minimal update with available data
          final transformedData = {
            'type': 'live_score',
            'channel': config.channel,
            'data': [
              potentialId,    // Match ID
              null,           // Reserved
              [0],            // Default home score
              [0],            // Default away score
              potentialStatus, // Status
              0,              // Default minute
            ],
          };
          
          _controller?.add(transformedData);
          debugPrint('📊 Alternative format match update: $potentialId');
          return;
        }
      }
    }
    
    debugPrint('❌ Could not parse alternative format');
  }

  int _calculateMinute(dynamic kickoffTimestamp) {
    if (kickoffTimestamp is int) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final elapsed = now - kickoffTimestamp;
      return (elapsed / 60).floor().clamp(0, 120); // Max 120 minutes
    }
    return 0;
  }

  void _handleError(error) {
    debugPrint('❌ WebSocket error: $error');
    _isConnected = false;
    _handleConnectionFailure();
  }

  void _handleDisconnection() {
    debugPrint('🔌 WebSocket connection closed');
    _isConnected = false;
    _handleConnectionFailure();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= config.maxReconnectAttempts) {
      debugPrint('❌ Max reconnection attempts reached (${config.maxReconnectAttempts})');
      if (config.enableMockData) {
        _startMockDataService();
      }
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(config.reconnectInterval, () async {
      _reconnectAttempts++;
      debugPrint('🔄 Reconnection attempt $_reconnectAttempts/${config.maxReconnectAttempts}');
      await connect();
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(config.heartbeatInterval, (_) {
      if (_isConnected && _channel != null) {
        _sendHeartbeat();
      }
    });
  }

  void _sendSubscription(String channel) {
    _sendMessage({
      'type': 'subscribe',
      'channel': channel,
    });
  }

  void _sendUnsubscription(String channel) {
    _sendMessage({
      'type': 'unsubscribe',
      'channel': channel,
    });
  }

  void _sendPusherSubscription(String channel) {
    _sendMessage({
      'event': 'pusher:subscribe',
      'data': {
        'channel': channel,
      },
    });
    debugPrint('📡 Sent Pusher subscription for channel: $channel');
  }

  void _sendHeartbeat() {
    if (config.isPusherProtocol) {
      _sendMessage({'event': 'pusher:ping', 'data': {}});
    } else {
      _sendMessage({'type': 'heartbeat'});
    }
  }

  void _sendMessage(Map<String, dynamic> message) {
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      debugPrint('Error sending WebSocket message: $e');
    }
  }
} 