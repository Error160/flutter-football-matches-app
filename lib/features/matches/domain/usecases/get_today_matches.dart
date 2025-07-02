import '../entities/match.dart';
import '../repositories/matches_repository.dart';

class GetTodayMatches {
  final MatchesRepository repository;

  GetTodayMatches(this.repository);

  Future<List<Match>> call() async {
    return await repository.getTodayMatches();
  }
} 