import 'package:eventify/eventify.dart';
import 'package:eventify/eventify.dart' as event;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/models/tag.dart';
import 'package:kophecy/providers/auth_provider.dart';
import 'package:kophecy/providers/navigation_provider.dart';
import 'package:kophecy/providers/theme_provider.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tinycolor2/tinycolor2.dart';

typedef MyEventListener = void Function(Event event, dynamic data);

mixin QuoteUI {
  Quote get quote;

  QuoteViewModel get viewModel;

  final ScreenshotController screenshotController = ScreenshotController();

  bool get isSaved => viewModel.savedQuotes.contains(quote);

  bool get canViewDetail => true;

  bool get canBookmark => true;

  bool get canShare => true;

  bool get canTranslate => true;

  bool canInteractWithQuote = true;

  bool get canInteract => canInteractWithQuote;

  set canInteract(bool value) {
    canInteractWithQuote = value;
  }

  void initWidgetState(MyEventListener eventListener) {
    Future.delayed(Duration.zero, () {
      Provider.of<event.EventEmitter>(Get.context!, listen: false)
          .on(Constants.shareQuoteEvent, this, eventListener);
    });
  }

  Widget get widgetToRender =>
      Consumer4<ThemeProvider, AuthProvider, NavigationProvider, EventEmitter>(
        builder: (context, themeProvider, authProvider, navigationProvider,
                eventEmitter, _) =>
            Screenshot(
          controller: screenshotController,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: themeProvider.currentTheme == 'dark'
                  ? TinyColor(Theme.of(context).backgroundColor).color.tint(5)
                  : TinyColor(Theme.of(context).backgroundColor)
                      .color
                      .lighten(15),
              borderRadius: BorderRadius.circular(
                Constants.kBorderRadius,
              ),
              border: Border.all(
                color: themeProvider.currentTheme == 'dark'
                    ? AppColors.whiteBackgroundColor.withOpacity(.09)
                    : AppColors.screenBackgroundColor.withOpacity(.008),
                width: .8,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                  color: themeProvider.currentTheme == 'dark'
                      ? AppColors.whiteBackgroundColor.withOpacity(.02)
                      : AppColors.screenBackgroundColor.withOpacity(.02),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: quote.tags
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            Tag tag = viewModel.tags
                                .firstWhere((tag) => tag.name == e.name);
                            viewModel.selectTag(tag);
                            navigationProvider.currentIndex = 1;
                          },
                          child: Text(
                            "#${e.name}",
                            style: TextStyles.textStyle.apply(
                              fontSizeDelta: -4,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.color
                                  ?.withOpacity(.85),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Text(
                        '"${quote.content}"',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 30,
                        style: TextStyles.textStyle.apply(
                          fontSizeDelta: 2,
                          fontWeightDelta: 8,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),

                Text(
                  "📙: ${quote.book}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.textStyle.apply(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(.9),
                    fontSizeDelta: -1,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),

                RichText(
                  text: TextSpan(
                      text: AppLocalizations.of(context)!.by,
                      style: TextStyles.textStyle.apply(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(.8),
                        fontSizeDelta: -2,
                      ),
                      children: [
                        TextSpan(
                          text: " ${quote.author}",
                          style: TextStyles.textStyle.apply(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontSizeDelta: -2,
                              fontWeightDelta: 10),
                        ),
                      ]),
                ),

                /*const SizedBox(
                        height: 16,
                      ),
                      MaterialButton(
                        elevation: 0.0,
                        onPressed: () {},
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Text(
                          'Read more'.toUpperCase(),
                          style: textStyle.apply(
                            color: Theme.of(context).backgroundColor,
                            fontSizeDelta: -2,
                          ),
                        ),
                      ),*/
                // const Spacer(),
                const SizedBox(
                  height: 16,
                ),

                if (canInteract)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              viewModel.selectQuote(quote, showDetail: false);
                              viewModel.selectScreenshotController(
                                  screenshotController);
                              eventEmitter.emit(Constants.shareQuoteEvent);
                            },
                            color: Theme.of(context).iconTheme.color,
                            icon: const Icon(
                              Iconsax.share,
                              size: 22,
                            ),
                          ),
                          if (canTranslate)
                            IconButton(
                              onPressed: () => viewModel.translateQuote(quote),
                              color: Theme.of(context).iconTheme.color,
                              icon: const Icon(
                                Iconsax.translate,
                                size: 22,
                              ),
                            ),
                          if (canViewDetail)
                            IconButton(
                              onPressed: () => viewModel.selectQuote(quote),
                              color: Theme.of(context).iconTheme.color,
                              icon: const Icon(
                                Iconsax.eye,
                                size: 22,
                              ),
                            ),
                          /*IconButton(
                                onPressed: () {
                                  viewModel.translateQuote(context, quote);

                                  onTranslate();
                                },
                                color: Theme.of(context).iconTheme.color,
                                icon: const Icon(
                                  Icons.translate,
                                  size: 22,
                                ),
                              ),*/
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (authProvider.status == Status.authenticated) {
                            viewModel.bookmark(quote);
                          } else {
                            Get.toNamed(login);
                          }
                        },
                        color: Theme.of(context).iconTheme.color,
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          size: 22,
                          color: isSaved ? AppColors.accentColor : null,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
}
