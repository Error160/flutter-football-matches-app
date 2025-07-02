import '../entities/match.dart';
import '../repositories/matches_repository.dart';

class GetTomorrowMatches {
  final MatchesRepository repository;

  GetTomorrowMatches(this.repository);

  Future<List<Match>> call() async {
    return await repository.getTomorrowMatches();
  }
} 