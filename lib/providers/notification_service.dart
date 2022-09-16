import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/extensions.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class NotificationService {
  RemoteMessage remoteMessage;

  NotificationService(this.remoteMessage);

  String get title => remoteMessage.notification?.title ?? "Kophecy";

  String get body => remoteMessage.notification?.body ?? "Kophecy";

  Map get data => remoteMessage.data;

  void showToast() {
    print("REMOTEMESSAGE ${remoteMessage.toString()}");

    Widget toastWidget = Material(
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: 40,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.secondaryColor,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/img/ico.png',
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: -2,
                      fontWeightDelta: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    body,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: -4,
                      fontWeightDelta: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showOverlayNotification(
      (context) => toastWidget,
      duration: const Duration(seconds: 12),
      position: NotificationPosition.bottom,
    );
  }

  static handleQuoteNotification(RemoteMessage remoteMessage) {
    Map data = remoteMessage.data;

    if (data.isNotEmpty && data.containsKey('quoteId')) {
      int quoteId = (data['quoteId'] as String).toInt();

      QuoteViewModel quoteViewModel =
          Provider.of<QuoteViewModel>(Get.context!, listen: false);

      Quote quote = quoteViewModel.quotes.where((q) => q.id == quoteId).first;

      if (Get.currentRoute != landing) {
        Get.offAndToNamed(landing);
      }

      quoteViewModel.selectQuote(quote);
    }
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      handleQuoteNotification(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(handleQuoteNotification);
  }
}
