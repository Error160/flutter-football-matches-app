import '../../domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.apiId,
    required super.name,
    required super.shortName,
    required super.logo,
    required super.score,
    required super.shirt,
    required super.isDefaultShirt,
    required super.national,
    super.country,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id']?.toString() ?? '',
      apiId: json['api_id']?.toString() ?? '',
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? json['shortName'] ?? '',
      logo: json['logo'] ?? json['logo_url'] ?? '',
      score: _parseScoreArray(json['score']),
      shirt: json['shirt']?.toString() ?? '',
      isDefaultShirt: json['is_default_shirt'] ?? false,
      national: json['national'] ?? false,
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'api_id': apiId,
      'name': name,
      'short_name': shortName,
      'logo': logo,
      'score': score,
      'shirt': shirt,
      'is_default_shirt': isDefaultShirt,
      'national': national,
      'country': country,
    };
  }

  factory TeamModel.fromEntity(Team team) {
    return TeamModel(
      id: team.id,
      apiId: team.apiId,
      name: team.name,
      shortName: team.shortName,
      logo: team.logo,
      score: team.score,
      shirt: team.shirt,
      isDefaultShirt: team.isDefaultShirt,
      national: team.national,
      country: team.country,
    );
  }

  static List<int> _parseScoreArray(dynamic scoreData) {
    if (scoreData is List) {
      return scoreData.map((e) => (e is int) ? e : 0).toList();
    }
    return [0, 0, 0, 0, 0, 0, 0]; // Default 7-element array
  }
} 