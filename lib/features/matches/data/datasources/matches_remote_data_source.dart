import 'package:flutter/foundation.dart';
import '../models/match_model.dart';
import '../models/matches_response_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

abstract class MatchesRemoteDataSource {
  Future<List<MatchModel>> getTodayMatches();
  Future<List<MatchModel>> getYesterdayMatches();
  Future<List<MatchModel>> getTomorrowMatches();
}

class MatchesRemoteDataSourceImpl implements MatchesRemoteDataSource {
  final ApiService apiService;

  MatchesRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<MatchModel>> getTodayMatches() async {
    return _getMatches(ApiConstants.todayMatches, 'today');
  }

  @override
  Future<List<MatchModel>> getYesterdayMatches() async {
    return _getMatches(ApiConstants.yesterdayMatches, 'yesterday');
  }

  @override
  Future<List<MatchModel>> getTomorrowMatches() async {
    return _getMatches(ApiConstants.tomorrowMatches, 'tomorrow');
  }

  Future<List<MatchModel>> _getMatches(String endpoint, String type) async {
    try {
      debugPrint('Fetching matches for: $type from $endpoint');
      final responseData = await apiService.get(endpoint);
      
      debugPrint('Successfully fetched matches');
      final responseModel = MatchesResponseModel.fromJson(responseData);
      final matches = responseModel.getAllMatches();
      return matches.map((match) => MatchModel.fromEntity(match)).toList();
    } on Failure catch (failure) {
      debugPrint('API Service error: ${failure.toString()}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw ServerFailure('Unexpected error occurred: $e');
    }
  }
} 