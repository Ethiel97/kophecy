import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Tag extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  @JsonKey(
    name: 'created',
    required: false,
  )
  final String? createdAt;

  @HiveField(2)
  final String name;

  Tag({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
