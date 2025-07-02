import '../../domain/entities/competition.dart';

class CompetitionModel extends Competition {
  const CompetitionModel({
    required super.id,
    required super.apiId,
    required super.name,
    required super.logo,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id']?.toString() ?? '',
      apiId: json['api_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'api_id': apiId,
      'name': name,
      'logo': logo,
    };
  }

  factory CompetitionModel.fromEntity(Competition competition) {
    return CompetitionModel(
      id: competition.id,
      apiId: competition.apiId,
      name: competition.name,
      logo: competition.logo,
    );
  }
} 