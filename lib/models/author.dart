import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Author extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bio;

  @HiveField(2)
  @JsonKey(name: 'created')
  final String createdAt;

  @HiveField(3)
  final String name;

  Author({
    required this.id,
    required this.bio,
    required this.name,
    required this.createdAt,
  });

  Author copyWith({
    String? id,
    String? bio,
    String? createdAt,
    String? name,
  }) {
    return Author(
      id: id ?? this.id,
      bio: bio ?? this.bio,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
