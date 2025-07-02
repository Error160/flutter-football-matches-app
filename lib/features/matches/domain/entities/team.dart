import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String apiId;
  final String name;
  final String shortName;
  final String logo;
  final List<int> score;
  final String shirt;
  final bool isDefaultShirt;
  final bool national;
  final String? country;

  const Team({
    required this.id,
    required this.apiId,
    required this.name,
    required this.shortName,
    required this.logo,
    required this.score,
    required this.shirt,
    required this.isDefaultShirt,
    required this.national,
    this.country,
  });

  @override
  List<Object?> get props => [
    id,
    apiId,
    name,
    shortName,
    logo,
    score,
    shirt,
    isDefaultShirt,
    national,
    country,
  ];

  Team copyWith({
    String? id,
    String? apiId,
    String? name,
    String? shortName,
    String? logo,
    List<int>? score,
    String? shirt,
    bool? isDefaultShirt,
    bool? national,
    String? country,
  }) {
    return Team(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logo: logo ?? this.logo,
      score: score ?? this.score,
      shirt: shirt ?? this.shirt,
      isDefaultShirt: isDefaultShirt ?? this.isDefaultShirt,
      national: national ?? this.national,
      country: country ?? this.country,
    );
  }

  // Helper methods for score access
  int get currentScore => score.isNotEmpty ? score[0] : 0;
  
  // The score array might represent different periods/stats
  // score[0] might be current score, others could be period scores
} 