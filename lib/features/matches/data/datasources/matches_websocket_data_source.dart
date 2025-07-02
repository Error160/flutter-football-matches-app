import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/match_model.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/team.dart';
import '../../../../core/services/websocket_service.dart';

abstract class MatchesWebSocketDataSource {
  Stream<Match> getMatchUpdates();
  Future<void> startListening();
  Future<void> stopListening();
}

class MatchesWebSocketDataSourceImpl implements MatchesWebSocketDataSource {
  final WebSocketService webSocketService;
  StreamController<Match>? _matchController;
  StreamSubscription<Map<String, dynamic>>? _serviceSubscription;
  
  // Use the same channel as configured in WebSocket service for Pusher
  static const String pusherChannel = 'thesports-football.matchs';
  static const String fallbackChannel = 'live-scores';

  MatchesWebSocketDataSourceImpl({required this.webSocketService});

  @override
  Stream<Match> getMatchUpdates() {
    _matchController ??= StreamController<Match>.broadcast();
    debugPrint('🎯 WebSocket Data Source: Providing match updates stream');
    debugPrint('🎯 Stream controller exists: ${_matchController != null}');
    debugPrint('🎯 Stream controller is closed: ${_matchController?.isClosed}');
    return _matchController!.stream;
  }

  @override
  Future<void> startListening() async {
    try {
      _matchController ??= StreamController<Match>.broadcast();
      
      if (!webSocketService.isConnected) {
        await webSocketService.connect();
      }
      
      // Subscribe to the Pusher channel for real match data
      webSocketService.subscribe(pusherChannel);
      
      _serviceSubscription?.cancel();
      _serviceSubscription = webSocketService.dataStream.listen(
        _handleWebSocketData,
        onError: _handleError,
      );
      
      debugPrint('✅ Started listening for match updates');
      debugPrint('🔄 WebSocket connected: ${webSocketService.isConnected}');
    } catch (e) {
      debugPrint('Error starting match updates listener: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _serviceSubscription?.cancel();
      _serviceSubscription = null;
      
      webSocketService.unsubscribe(pusherChannel);
      
      debugPrint('Stopped listening for match updates');
    } catch (e) {
      debugPrint('Error stopping match updates listener: $e');
    }
  }

  void _handleWebSocketData(Map<String, dynamic> data) {
    try {
      final messageType = data['type'] as String?;
      final channel = data['channel'] as String?;
      
      debugPrint('🎯 WebSocket Data Source received: type=$messageType, channel=$channel');
      debugPrint('🎯 Full data: $data');
      
      switch (messageType) {
        case 'match_update':
          _handleMatchUpdate(data);
          break;
        case 'live_score':
          _handleLiveScore(data);
          break;
        case 'channel_data':
          if (channel == pusherChannel || channel == fallbackChannel) {
            _handleChannelData(data);
          }
          break;
        default:
          debugPrint('⚠️ Unknown message type: $messageType');
      }
    } catch (e) {
      debugPrint('❌ Error handling WebSocket data: $e');
    }
  }

  void _handleMatchUpdate(Map<String, dynamic> data) {
    try {
      final matchData = data['data'] as Map<String, dynamic>?;
      if (matchData != null) {
        final match = MatchModel.fromJson(matchData);
        _matchController?.add(match);
        debugPrint('Received match update for: ${match.id}');
      }
    } catch (e) {
      debugPrint('Error handling match update: $e');
    }
  }

  void _handleLiveScore(Map<String, dynamic> data) {
    try {
      debugPrint('🏈 Processing live score data: $data');
      final scoreData = data['data'] as List<dynamic>?;
      
      if (scoreData != null && scoreData.length >= 6) {
        final matchId = scoreData[0]?.toString();
        final homeTeamData = scoreData[2] as List<dynamic>?;
        final awayTeamData = scoreData[3] as List<dynamic>?;
        final statusData = scoreData[4];
        final minuteData = scoreData[5];

        debugPrint('🏈 Extracted: ID=$matchId, Home=$homeTeamData, Away=$awayTeamData, Status=$statusData, Min=$minuteData');

        if (matchId != null && 
            homeTeamData != null && 
            awayTeamData != null &&
            homeTeamData.isNotEmpty && 
            awayTeamData.isNotEmpty) {
          
          final homeScore = _parseInt(homeTeamData[0]) ?? 0;
          final awayScore = _parseInt(awayTeamData[0]) ?? 0;
          final minute = _parseInt(minuteData);
          final statusId = _parseInt(statusData) ?? 2;

          final liveMatch = _createLiveMatchUpdate(
            matchId, 
            homeScore, 
            awayScore, 
            statusId, 
            minute,
            scoreData,
          );
          
          _matchController?.add(liveMatch);
          debugPrint('✅ Live score sent to stream: $matchId ($homeScore-$awayScore) - Status: $statusId');
        } else {
          debugPrint('⚠️ Invalid live score data: missing required fields');
        }
      } else {
        debugPrint('⚠️ Invalid live score data: insufficient length (${scoreData?.length})');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error handling live score: $e');
      debugPrint('❌ Stack trace: $stackTrace');
    }
  }

  void _handleChannelData(Map<String, dynamic> data) {
    try {
      final channelData = data['data'];
      if (channelData is Map<String, dynamic>) {
        _handleMatchUpdate({'data': channelData});
      } else if (channelData is List<dynamic>) {
        _handleLiveScore({'data': channelData});
      }
    } catch (e) {
      debugPrint('Error handling channel data: $e');
    }
  }

  Match _createLiveMatchUpdate(
    String matchId,
    int homeScore,
    int awayScore,
    int statusId,
    int? minute,
    List<dynamic> liveData,
  ) {
    return MatchModel(
      id: matchId,
      apiId: matchId,
      homeTeam: _createEmptyTeam(),
      awayTeam: _createEmptyTeam(),
      homeScore: homeScore,
      awayScore: awayScore,
      matchDate: DateTime.now(),
      status: MatchStatus.fromCode(statusId),
      matchStatusId: statusId,
      matchStatusDescription: _getStatusDescription(statusId),
      matchDay: DateTime.now().toString().split(' ')[0],
      matchTime: DateTime.now().toString().split(' ')[1],
      kickOff: 0,
      mustDisplay: 1,
      published: 1,
      minute: minute,
      liveScoreData: liveData.map((e) => _parseInt(e) ?? 0).toList(),
    );
  }

  Team _createEmptyTeam() {
    return const Team(
      id: '',
      apiId: '',
      name: '',
      shortName: '',
      logo: '',
      score: [0],
      shirt: '',
      isDefaultShirt: true,
      national: false,
    );
  }

  void _handleError(error) {
    debugPrint('WebSocket data stream error: $error');
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  String _getStatusDescription(int statusId) {
    final status = MatchStatus.fromCode(statusId);
    return switch (status) {
      MatchStatus.abnormal => 'Abnormal',
      MatchStatus.notStarted => 'Not started',
      MatchStatus.firstHalf => 'First half',
      MatchStatus.halfTime => 'Half-time',
      MatchStatus.secondHalf => 'Second half',
      MatchStatus.overtime => 'Overtime',
      MatchStatus.penaltyShootout => 'Penalty Shoot-out',
      MatchStatus.finished => 'Finished',
      MatchStatus.delayed => 'Delayed',
      MatchStatus.interrupted => 'Interrupted',
      MatchStatus.cutInHalf => 'Abandoned',
      MatchStatus.cancelled => 'Cancelled',
      MatchStatus.toBeDetermined => 'To be determined',
      _ => 'Unknown',
    };
  }

  void dispose() {
    _serviceSubscription?.cancel();
    _matchController?.close();
  }
}