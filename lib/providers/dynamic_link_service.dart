import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/extensions.dart';
import 'package:kophecy/utils/log.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:provider/provider.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved

    if (data != null) {
      LogUtils.log("DYNAMIC LINK DATA: $data");

      _handleDeepLink(data);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      LogUtils.log("DYNAMIC LINK DATA background: $dynamicLinkData");

      _handleDeepLink(dynamicLinkData, openedFromLink: false);
    }).onError((error) {
      // Handle errors
      LogUtils.log(error);
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data,
      {bool openedFromLink = true}) async {
    final Uri deepLink = data!.link;
    print('_handleDeepLink | deeplink: $deepLink');

    QuoteViewModel quoteViewModel =
        Provider.of<QuoteViewModel>(Get.context!, listen: false);

    int? quoteId = deepLink.queryParameters['quoteId']?.toInt();

    Quote quote = quoteViewModel.quotes.where((q) => q.id == quoteId).first;

    if (Get.currentRoute != landing) {
      Get.offAndToNamed(landing);
    }

    quoteViewModel.selectQuote(quote);
  }

  Future<String> createDynamicLink({required Quote quote}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constants.dynamicLinkDomain,
      link: Uri.parse(
        'https://kophecy.vercel.app?quoteId=${quote.id}',
      ),
      androidParameters: const AndroidParameters(
        packageName: Constants.appBundleName,
      ),
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      iosParameters: const IOSParameters(
        bundleId: Constants.appBundleName,
        appStoreId: '6443527758',
        minimumVersion: '1.0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title:
            '${AppLocalizations.of(Get.context!)!.kophecy_quote} - Ellen G. White',
        description: quote.content,
        imageUrl: Uri.parse(
            "https://raw.githubusercontent.com/Ethiel97/kophecy/master/assets/img/banner.jpg"),
      ),
    );

    final ShortDynamicLink shortDynamicUrl =
        await FirebaseDynamicLinks.instance.buildShortLink(
      parameters,
      shortLinkType: ShortDynamicLinkType.short,
    );

    return shortDynamicUrl.shortUrl.toString();
  }
}
