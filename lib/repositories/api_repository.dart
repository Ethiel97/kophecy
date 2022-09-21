import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kophecy/models/author.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/models/tag.dart';
import 'package:kophecy/providers/auth_provider.dart';
import 'package:kophecy/repositories/i_repository.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/log.dart';
import 'package:kophecy/utils/secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

///
class APIRepository implements IRepository {
  static var dio = Dio();

  InterceptorsWrapper interceptorsWrapper() =>
      InterceptorsWrapper(onRequest: (options, handler) async {
        try {
          options.headers = {
            'content-type': 'application/json',
            'accept-type': 'application/json'
          };

          /*if (await SecureStorageService.readItem(key: authTokenKey) != null) {
            options.headers['Authorization'] =
                'Bearer ${(await SecureStorageService.readItem(key: authTokenKey))}';
          }*/

          if (Provider.of<AuthProvider>(Get.context!, listen: false).status ==
              Status.authenticated) {
            options.headers['Authorization'] =
                'Bearer ${(await SecureStorageService.readItem(key: authTokenKey))}';
          }
        } catch (e) {
          print(e);
        }

        // options.

        // Do something before request is sent
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // LogUtils.log("uri: ${response.realUri.path.toString()}");

        // LogUtils.log(response.data);
        return handler.resolve(response);
      }, onError: (DioError e, handler) {
        LogUtils.log("dio error ${e.response?.toString()}");
        // Do something with response error
        return handler.resolve(e.response!); //continue
      });

  final String apiUrl;

  APIRepository({required this.apiUrl}) {
    dio.interceptors.add(interceptorsWrapper());
  }

  @override
  Future<List<Author>> getAuthors({
    Map<String, dynamic> query = const {},
  }) async {
    String url = 'authors?';

    String lastKey = "";
    // query.
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    final response = await dio.get(apiUrl + url);

    return List<Author>.from(response.data.map((x) => Author.fromJson(x)));
  }

  @override
  Future<List<Quote>> getQuotes({
    Map<String, dynamic> query = const {},
  }) async {
    String url = 'quotes?';
    String lastKey = "";
    // query.
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    final response = await dio.get(apiUrl + url);

    // var data = jsonDecode(response.body);
    /*List<Quote> quotes = [];
    for (var quoteJson in data['results']) {
      var tempQuote = await Quote.create(quoteJson);
      quotes.add(tempQuote);
    }
    return quotes;*/

    return List<Quote>.from(response.data.map((x) => Quote.fromJson(x)));
  }

  @override
  Future<List<Tag>> getTags({
    Map<String, dynamic> query = const {},
  }) async {
    String url = 'tags?';

    String lastKey = "";
    // query.
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    final response = await dio.get(apiUrl + url);

    return List<Tag>.from(response.data.map((x) => Tag.fromJson(x)));
  }

  @override
  Future<List<Quote>> getQuotesForAuthor(String authorId) async {
    String url = 'quotes?$authorId';

    final response = await dio.get(apiUrl + url);

    return List<Quote>.from(response.data.map((x) => Quote.fromJson(x)));
  }

  @override
  Future<Quote> getSingleQuote(String quoteId) async {
    String url = "quotes/$quoteId";
    final response = await dio.get(apiUrl + url);

    return Quote.fromJson(response.data);
  }

  @override
  Future<Quote> getRandomQuote({
    Map<String, dynamic> query = const {},
  }) async {
    String url = 'quotes/random?';
    String lastKey = "";
    // query.
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    query.forEach((key, value) {
      url += "$key=$value&";
    });

    final response = await dio.get(apiUrl + url);

    return (await Quote.create(response.data));
  }

  @override
  Future<Author> getSingleAuthor(String authorId) async {
    String url = "authors/$authorId";

    final response = await dio.get(apiUrl + url);

    return Author.fromJson(response.data);
  }

  Future<String> translateToAppLocale({
    required String text,
    String source = "fr",
    required String target,
  }) async =>
      (target != source)
          ? (await GoogleTranslator().translate(text, from: source, to: target))
              .text
          : text;

  @override
  Future<List<Quote>> getQuotesForTag(String? tags) async {
    String? url = "quotes?";

    url = "${url}tags=$tags";

    final response = await dio.get(apiUrl + url);

    /*List<Quote> quotes = [];
    for (var quoteJson in response.data) {
      var tempQuote = await Quote.create(quoteJson);
      quotes.add(tempQuote);
    }

    return quotes;*/
    return List<Quote>.from(response.data.map((x) => Quote.fromJson(x)));
  }

  static Future<Map<String, dynamic>> login(Map data) async {
    var response = await dio.post("${Constants.customApiUrl}auth/local", data: {
      ...data,
    });

    print("RESPONSE: ${response.data}");

    return response.data;
  }

  static Future<Map<String, dynamic>> register(Map data) async {
    var response =
        await dio.post("${Constants.customApiUrl}auth/local/register", data: {
      ...data,
    });

    // print("response: $")

    return response.data;
  }

  //delete user account
  static Future<Map<String, dynamic>> deleteAccount(String id) async {
    var response = await dio.delete(
      "${Constants.customApiUrl}users/$id",
    );

    return response.data;
  }

  static Future<Map<String, dynamic>> fetchMe() async {
    var response = await dio.get("${Constants.customApiUrl}users/me");

    return response.data;
  }

  static Future<List> fetchUserSavedQuotes() async {
    var response = await dio.get("${Constants.customApiUrl}saved-quotes/user");

    // LogUtils.log("SAVED WALLPAPERS: ${response.data['data']}");

    return response.data['data'];
  }

  static saveQuote(int quoteId) async {
    var response =
        await dio.post("${Constants.customApiUrl}saved-quotes", data: {
      "data": {"uid": quoteId}
    });

    LogUtils.log("RESPONSE USER SAVED QUOTES: ${response.data}");
  }

  static deleteSavedQuote(int quoteId) async {
    var response = await dio.delete(
      "${Constants.customApiUrl}saved-quotes/remove/$quoteId",
    );

    LogUtils.log("RESPONSE USER SAVED QUOTES: ${response.data}");
  }

  static deleteUserSavedQuotes() async {
    var response = await dio.delete(
      "${Constants.customApiUrl}saved-quotes/remove",
    );
  }
}
