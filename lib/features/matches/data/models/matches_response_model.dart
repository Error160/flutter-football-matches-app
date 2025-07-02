import '../../domain/entities/match.dart';
import '../../domain/entities/competition.dart';
import 'match_model.dart';
import 'competition_model.dart';

class MatchesResponseModel {
  final List<CompetitionWithMatches> data;

  const MatchesResponseModel({
    required this.data,
  });

  factory MatchesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return MatchesResponseModel(
      data: dataList
          .map((item) => CompetitionWithMatches.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  // Helper method to get all matches from all competitions
  List<Match> getAllMatches() {
    return data.expand((competitionWithMatches) => competitionWithMatches.matches).toList();
  }

  // Helper method to get matches by competition
  List<Match> getMatchesByCompetition(String competitionId) {
    final competition = data.firstWhere(
      (item) => item.competition.id == competitionId,
      orElse: () => const CompetitionWithMatches(
        competition: Competition(id: '', apiId: '', name: '', logo: ''),
        matches: [],
      ),
    );
    return competition.matches;
  }
}

class CompetitionWithMatches {
  final Competition competition;
  final List<Match> matches;

  const CompetitionWithMatches({
    required this.competition,
    required this.matches,
  });

  factory CompetitionWithMatches.fromJson(Map<String, dynamic> json) {
    final competition = CompetitionModel.fromJson(json['competition'] ?? {});
    final matchesList = json['matches'] as List<dynamic>? ?? [];
    
    final matches = matchesList
        .map((matchJson) => MatchModel.fromJsonWithCompetition(
              matchJson as Map<String, dynamic>,
              competition,
            ))
        .toList();

    return CompetitionWithMatches(
      competition: competition,
      matches: matches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'competition': (competition as CompetitionModel).toJson(),
      'matches': matches.map((match) => (match as MatchModel).toJson()).toList(),
    };
  }
} 