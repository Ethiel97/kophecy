import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class Constants {
  static const String appName = 'Kophecy';
  static String apiUrl = '${dotenv.env['API_URL']}';
  static const String appBundleName = 'com.deventhusiast.kophecy';
  static String customApiUrl = '${dotenv.env['CUSTOM_API_URL']}';
  static String translationApiUrl = '${dotenv.env['TRANSLATION_API_URL']}';
  static String translationApiKey = '${dotenv.env['TRANSLATION_API_KEY']}';
  static const String quotesScreenSubtitle =
      "L'esprit de prophétie au quotidien 😎";
  static const String shareQuoteEvent = 'SHARE_QUOTE_EVENT';
  static const String dailyRandomQuoteTopic = 'DAILY_RANDOM_QUOTE_TOPIC';
  static const String testTopic = 'MY_CUSTOM_TEST_TOPIC';
  static String slogan =
      '${AppLocalizations.of(Get.context!)?.sop_everyday} 😋';
  static const kDuration = 300;
  static const dynamicLinkDomain = 'https://kophecy.page.link';
  static const kBorderRadius = 12.0;
  static const mainAuthorName = 'Ellen G. White';

  static const quotesBox = 'quotes';
  static const authorsBox = 'authors';
  static const tagsBox = 'tags';
}
