import '../../domain/entities/match.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/competition.dart';
import 'team_model.dart';

class MatchModel extends Match {
  const MatchModel({
    required super.id,
    required super.apiId,
    required super.homeTeam,
    required super.awayTeam,
    required super.homeScore,
    required super.awayScore,
    required super.matchDate,
    required super.status,
    required super.matchStatusId,
    required super.matchStatusDescription,
    required super.matchDay,
    required super.matchTime,
    required super.kickOff,
    required super.mustDisplay,
    required super.published,
    super.competition,
    super.venue,
    super.league,
    super.minute,
    super.matchWeek,
    super.liveScoreData,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id']?.toString() ?? '',
      apiId: json['api_id']?.toString() ?? '',
      homeTeam: TeamModel.fromJson(json['home_team'] ?? {}),
      awayTeam: TeamModel.fromJson(json['away_team'] ?? {}),
      homeScore: _parseScore(json['home_team']?['score']?[0] ?? 0),
      awayScore: _parseScore(json['away_team']?['score']?[0] ?? 0),
      matchDate: _parseDateTime(json['match_day'], json['match_time']),
      status: MatchStatus.fromCode(_parseInt(json['match_status_id']) ?? 1),
      matchStatusId: _parseInt(json['match_status_id']) ?? 1,
      matchStatusDescription: json['match_status_description']?.toString() ?? 'Not started',
      matchDay: json['match_day']?.toString() ?? '',
      matchTime: json['match_time']?.toString() ?? '',
      kickOff: _parseInt(json['kick_off']) ?? 0,
      mustDisplay: _parseInt(json['must_display']) ?? 0,
      published: _parseInt(json['published']) ?? 1,
      venue: json['venue'],
      league: json['league'] ?? json['competition']?['name'],
      minute: _parseInt(json['minute']),
      matchWeek: json['match_week']?.toString(),
      liveScoreData: _parseLiveScoreData(json['live_score_data']),
    );
  }

  factory MatchModel.fromJsonWithCompetition(
    Map<String, dynamic> json, 
    Competition? competition,
  ) {
    return MatchModel(
      id: json['id']?.toString() ?? '',
      apiId: json['api_id']?.toString() ?? '',
      homeTeam: TeamModel.fromJson(json['home_team'] ?? {}),
      awayTeam: TeamModel.fromJson(json['away_team'] ?? {}),
      homeScore: _parseScore(json['home_team']?['score']?[0] ?? 0),
      awayScore: _parseScore(json['away_team']?['score']?[0] ?? 0),
      matchDate: _parseDateTime(json['match_day'], json['match_time']),
      status: MatchStatus.fromCode(_parseInt(json['match_status_id']) ?? 1),
      matchStatusId: _parseInt(json['match_status_id']) ?? 1,
      matchStatusDescription: json['match_status_description']?.toString() ?? 'Not started',
      matchDay: json['match_day']?.toString() ?? '',
      matchTime: json['match_time']?.toString() ?? '',
      kickOff: _parseInt(json['kick_off']) ?? 0,
      mustDisplay: _parseInt(json['must_display']) ?? 0,
      published: _parseInt(json['published']) ?? 1,
      competition: competition,
      venue: json['venue'],
      league: competition?.name ?? json['league'],
      minute: _parseInt(json['minute']),
      matchWeek: json['match_week']?.toString(),
      liveScoreData: _parseLiveScoreData(json['live_score_data']),
    );
  }

  factory MatchModel.fromEntity(Match match) {
    return MatchModel(
      id: match.id,
      apiId: match.apiId,
      homeTeam: match.homeTeam,
      awayTeam: match.awayTeam,
      homeScore: match.homeScore,
      awayScore: match.awayScore,
      matchDate: match.matchDate,
      status: match.status,
      matchStatusId: match.matchStatusId,
      matchStatusDescription: match.matchStatusDescription,
      matchDay: match.matchDay,
      matchTime: match.matchTime,
      kickOff: match.kickOff,
      mustDisplay: match.mustDisplay,
      published: match.published,
      competition: match.competition,
      venue: match.venue,
      league: match.league,
      minute: match.minute,
      matchWeek: match.matchWeek,
      liveScoreData: match.liveScoreData,
    );
  }

  MatchModel updateWithWebSocketData(List<dynamic> wsData) {
    if (wsData.length >= 6) {
      final matchId = wsData[0]?.toString() ?? '';
      final homeScore = _parseInt(wsData[2]?[0]) ?? 0;
      final awayScore = _parseInt(wsData[3]?[0]) ?? 0;
      
      if (matchId == id) {
        return copyWith(
          homeScore: homeScore,
          awayScore: awayScore,
          liveScoreData: wsData.cast<int>(),
          status: MatchStatus.firstHalf,
        );
      }
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'api_id': apiId,
      'home_team': (homeTeam as TeamModel).toJson(),
      'away_team': (awayTeam as TeamModel).toJson(),
      'match_status_id': matchStatusId,
      'match_status_description': matchStatusDescription,
      'match_day': matchDay,
      'match_time': matchTime,
      'kick_off': kickOff,
      'must_display': mustDisplay,
      'published': published,
      'venue': venue,
      'league': league,
      'minute': minute,
      'match_week': matchWeek,
      'live_score_data': liveScoreData,
    };
  }

  @override
  MatchModel copyWith({
    String? id,
    String? apiId,
    Team? homeTeam,
    Team? awayTeam,
    int? homeScore,
    int? awayScore,
    DateTime? matchDate,
    MatchStatus? status,
    int? matchStatusId,
    String? matchStatusDescription,
    String? matchDay,
    String? matchTime,
    int? kickOff,
    int? mustDisplay,
    int? published,
    Competition? competition,
    String? venue,
    String? league,
    int? minute,
    String? matchWeek,
    List<int>? liveScoreData,
  }) {
    return MatchModel(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      matchDate: matchDate ?? this.matchDate,
      status: status ?? this.status,
      matchStatusId: matchStatusId ?? this.matchStatusId,
      matchStatusDescription: matchStatusDescription ?? this.matchStatusDescription,
      matchDay: matchDay ?? this.matchDay,
      matchTime: matchTime ?? this.matchTime,
      kickOff: kickOff ?? this.kickOff,
      mustDisplay: mustDisplay ?? this.mustDisplay,
      published: published ?? this.published,
      competition: competition ?? this.competition,
      venue: venue ?? this.venue,
      league: league ?? this.league,
      minute: minute ?? this.minute,
      matchWeek: matchWeek ?? this.matchWeek,
      liveScoreData: liveScoreData ?? this.liveScoreData,
    );
  }

  static int _parseScore(dynamic score) {
    if (score is int) return score;
    if (score is String) return int.tryParse(score) ?? 0;
    return 0;
  }

  static DateTime _parseDateTime(dynamic matchDay, dynamic matchTime) {
    if (matchDay is String && matchTime is String) {
      try {
        final dateParts = matchDay.split('/');
        final timeParts = matchTime.split(':');
        
        if (dateParts.length == 3 && timeParts.length == 2) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          return DateTime(year, month, day, hour, minute);
        }
      } catch (e) {
        // Parsing failed, return current date
      }
    }
    return DateTime.now();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<int>? _parseLiveScoreData(dynamic data) {
    if (data is List) {
      return data.map((e) => _parseInt(e) ?? 0).toList();
    }
    return null;
  }
} 