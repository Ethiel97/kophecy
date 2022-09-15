import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kophecy/main.dart';
import 'package:kophecy/models/tag.dart';
import 'package:kophecy/utils/constants.dart';

part 'quote.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Quote extends HiveObject {
  @HiveField(0)
  @JsonKey(required: false)
  final int id;

  @HiveField(1)
  @JsonKey(fromJson: readAuthor)
  final String author;

  @HiveField(2)
  @JsonKey(name: 'livre')
  final String book;

  @HiveField(3)
  final List<Tag> tags;

  @HiveField(4)
  @JsonKey(name: 'body')
  final String content;

  @HiveField(5)
  @JsonKey(name: 'author_id')
  final int authorId;

  @HiveField(6)
  bool saved;

  @HiveField(7)
  final String name;

  Quote({
    required this.id,
    required this.author,
    required this.book,
    required this.authorId,
    required this.content,
    required this.name,
    required this.tags,
    this.saved = false,
  });

  static Future<Quote> create(Map<String, dynamic> json) async {
    Quote quote = Quote.fromJson(json);

    // final APIRepository apiRepository = APIRepository(apiUrl: Constants.apiUrl);

    /*String translatedContent = await apiRepository.translateToAppLocale(
        text: quote.content,
        target: WidgetsBinding.instance.window.locale.languageCode);*/

    return Quote(
      author: quote.author,
      id: quote.id,
      name: quote.name,
      content: quote.content,
      tags: quote.tags,
      book: quote.book,
      saved: quote.saved,
      authorId: quote.authorId,
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Quote copyWith({
    int? id,
    String? author,
    String? content,
    List<Tag>? tags,
    String? dateAdded,
    String? book,
    String? name,
    int? authorId,
    bool? saved = false,
  }) =>
      Quote(
        author: author ?? this.author,
        id: id ?? this.id,
        name: name ?? this.name,
        content: content ?? this.content,
        book: book ?? this.book,
        authorId: authorId ?? this.authorId,
        tags: tags ?? this.tags,
        saved: saved ?? this.saved,
      );

  List<int> get tagIds => tags.map((e) => e.id).toList();

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  set isSaved(bool saved) => this.saved = saved;

  get isBookMarked => Hive.box(quotesBox).values.contains(this);
}

String readAuthor(String? author) {
  return author ?? Constants.mainAuthorName;
}
