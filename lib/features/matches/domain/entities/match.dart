import 'package:equatable/equatable.dart';
import 'team.dart';
import 'competition.dart';

enum MatchStatus {
  abnormal(0),         // Abnormal (suggest hiding)
  notStarted(1),       // Not started
  firstHalf(2),        // First half
  halfTime(3),         // Half-time
  secondHalf(4),       // Second half
  overtime(5),         // Overtime
  overtimeDeprecated(6), // Overtime (deprecated)
  penaltyShootout(7),  // Penalty Shoot-out
  finished(8),         // End
  delayed(9),          // Delay
  interrupted(10),     // Interrupt
  cutInHalf(11),       // Cut in half
  cancelled(12),       // Cancel
  toBeDetermined(13);  // To be determined

  const MatchStatus(this.code);
  final int code;

  // Helper methods for common status checks
  bool get isLive => this == firstHalf || this == secondHalf || this == overtime || this == penaltyShootout;
  bool get isFinished => this == finished;
  bool get isScheduled => this == notStarted;
  bool get isPaused => this == halfTime;
  bool get isDelayed => this == delayed || this == interrupted;
  bool get isCancelled => this == cancelled;
  bool get isAbnormal => this == abnormal;
  bool get shouldHide => this == abnormal;

  // Get status from code
  static MatchStatus fromCode(int code) {
    for (MatchStatus status in MatchStatus.values) {
      if (status.code == code) {
        return status;
      }
    }
    return notStarted; // Default fallback
  }
}

class Match extends Equatable {
  final String id;
  final String apiId;
  final Team homeTeam;
  final Team awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime matchDate;
  final MatchStatus status;
  final int matchStatusId;
  final String matchStatusDescription;
  final String matchDay;
  final String matchTime;
  final int kickOff;
  final int mustDisplay;
  final int published;
  final Competition? competition;
  final String? venue;
  final String? league;
  final int? minute;
  final String? matchWeek;
  final List<int>? liveScoreData; // For WebSocket updates

  const Match({
    required this.id,
    required this.apiId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchDate,
    required this.status,
    required this.matchStatusId,
    required this.matchStatusDescription,
    required this.matchDay,
    required this.matchTime,
    required this.kickOff,
    required this.mustDisplay,
    required this.published,
    this.competition,
    this.venue,
    this.league,
    this.minute,
    this.matchWeek,
    this.liveScoreData,
  });

  @override
  List<Object?> get props => [
    id,
    apiId,
    homeTeam,
    awayTeam,
    homeScore,
    awayScore,
    matchDate,
    status,
    matchStatusId,
    matchStatusDescription,
    matchDay,
    matchTime,
    kickOff,
    mustDisplay,
    published,
    competition,
    venue,
    league,
    minute,
    matchWeek,
    liveScoreData,
  ];

  Match copyWith({
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
    return Match(
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

  bool get isLive => status.isLive;
  bool get isFinished => status.isFinished;
  bool get isScheduled => status.isScheduled;
  bool get isPaused => status.isPaused;
  bool get isDelayed => status.isDelayed;
  bool get isCancelled => status.isCancelled;
  bool get shouldHide => status.shouldHide;

  String get scoreDisplay => '$homeScore - $awayScore';
  
  // Simple status display - use MatchStatusHelper.getLocalizedStatus() for localized version
  String get statusDisplay {
    switch (status) {
      case MatchStatus.firstHalf:
      case MatchStatus.secondHalf:
        return minute != null ? "$minute'" : 'LIVE';
      case MatchStatus.halfTime:
        return 'HT';
      case MatchStatus.overtime:
        return minute != null ? "ET $minute'" : 'ET';
      case MatchStatus.penaltyShootout:
        return 'PENS';
      case MatchStatus.finished:
        return 'FT';
      case MatchStatus.notStarted:
        return 'vs';
      case MatchStatus.delayed:
        return 'DELAYED';
      case MatchStatus.interrupted:
        return 'INT';
      case MatchStatus.cancelled:
        return 'CANCELLED';
      case MatchStatus.toBeDetermined:
        return 'TBD';
      case MatchStatus.cutInHalf:
        return 'ABANDONED';
      case MatchStatus.overtimeDeprecated:
        return 'ET';
      case MatchStatus.abnormal:
        return 'ERROR';
    }
  }
} 