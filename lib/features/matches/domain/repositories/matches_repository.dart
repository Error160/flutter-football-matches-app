import '../entities/match.dart';

abstract class MatchesRepository {
  Future<List<Match>> getTodayMatches();
  Future<List<Match>> getYesterdayMatches();
  Future<List<Match>> getTomorrowMatches();
  Stream<Match> getMatchUpdates();
} 