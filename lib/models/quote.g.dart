// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 0;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      id: fields[0] as int,
      author: fields[1] as String,
      book: fields[2] as String,
      authorId: fields[5] as int,
      content: fields[4] as String,
      name: fields[7] as String,
      tags: (fields[3] as List).cast<Tag>(),
      saved: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.book)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.authorId)
      ..writeByte(6)
      ..write(obj.saved)
      ..writeByte(7)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      id: json['id'] as int,
      author: readAuthor(json['author'] as String?),
      book: json['livre'] as String,
      authorId: json['author_id'] as int,
      content: json['body'] as String,
      name: json['name'] as String,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      saved: json['saved'] as bool? ?? false,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'livre': instance.book,
      'tags': instance.tags,
      'body': instance.content,
      'author_id': instance.authorId,
      'saved': instance.saved,
      'name': instance.name,
    };
