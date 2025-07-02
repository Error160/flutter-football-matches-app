import 'package:equatable/equatable.dart';

class Competition extends Equatable {
  final String id;
  final String apiId;
  final String name;
  final String logo;

  const Competition({
    required this.id,
    required this.apiId,
    required this.name,
    required this.logo,
  });

  @override
  List<Object?> get props => [id, apiId, name, logo];

  Competition copyWith({
    String? id,
    String? apiId,
    String? name,
    String? logo,
  }) {
    return Competition(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      name: name ?? this.name,
      logo: logo ?? this.logo,
    );
  }
} 