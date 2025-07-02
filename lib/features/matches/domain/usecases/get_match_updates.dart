import 'package:dartz/dartz.dart';
import '../entities/match.dart';
import '../repositories/matches_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';

class GetMatchUpdates implements StreamUseCase<Match, NoParams> {
  final MatchesRepository repository;

  GetMatchUpdates(this.repository);

  @override
  Stream<Either<Failure, Match>> call(NoParams params) {
    return repository.getMatchUpdates()
        .map<Either<Failure, Match>>((match) => Right(match))
        .handleError((error) => Left(ServerFailure(error.toString())));
  }
} 