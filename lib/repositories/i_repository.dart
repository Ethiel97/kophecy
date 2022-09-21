import 'package:kophecy/models/author.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/models/tag.dart';

abstract class IRepository<T> {
  Future<List<Quote>> getQuotes({Map<String, dynamic> query = const {}});

  Future<List<Author>> getAuthors({Map<String, dynamic> query = const {}});

  Future<Quote> getSingleQuote(int quoteId);

  Future<Author> getSingleAuthor(String authorId);

  Future<List<Quote>> getQuotesForAuthor(String authorId);

  Future<List<Tag>> getTags();

  Future<List<Quote>> getQuotesForTag(String tags);

  Future<Quote> getRandomQuote({Map<String, dynamic> query = const {}});
}
