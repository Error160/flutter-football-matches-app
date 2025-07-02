import '../entities/match.dart';
import '../repositories/matches_repository.dart';

class GetYesterdayMatches {
  final MatchesRepository repository;

  GetYesterdayMatches(this.repository);

  Future<List<Match>> call() async {
    return await repository.getYesterdayMatches();
  }
} 