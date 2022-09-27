import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kophecy/main.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/models/tag.dart';
import 'package:kophecy/providers/auth_provider.dart';
import 'package:kophecy/providers/dynamic_link_service.dart';
import 'package:kophecy/repositories/api_repository.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/extensions.dart';
import 'package:kophecy/utils/log.dart';
import 'package:kophecy/widgets/quote_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'base_view_model.dart';

class QuoteViewModel extends BaseViewModel {
  List<Quote> quotes = [];

  late ScreenshotController screenshotController;

  List<Quote> filteredQuotes = [];

  List<Tag> tags = [];

  List<Tag> selectedTags = [];

  late Quote quote;

  late Quote selectedQuote;

  bool canInteractWithQuote = true;

  bool get canInteract => canInteractWithQuote;

  ScreenshotController get currentScreenshotController => screenshotController;

  set canInteract(bool value) {
    canInteractWithQuote = value;
    reloadState();
  }

  bool isSharing = false;

  @override
  int get size => quotes.length;

  String translatedText = "";
  late Box<Quote> boxQuotes;

  // translatedText

  List<Quote> get savedBoxQuotes => boxQuotes.values.toList();

  List<int> get savedBoxQuotesIds =>
      boxQuotes.values.toList().map((e) => e.id).toList();

  // List<int> get quotesIds => quotes

  List<Quote> savedQuotes = [];

  @override
  FutureOr<void> init() async {
    try {
      await Hive.openBox(Constants.quotesBox);
    } catch (e) {
      // LogUtils.log(e);
    }
    boxQuotes = Hive.box(Constants.quotesBox);
    // await getRandomQuote();

    if (tags.isEmpty) {
      await fetchTags();
    }
    await fetchAll(query: {});

    if (Provider.of<AuthProvider>(Get.context!, listen: false).status ==
        Status.authenticated) {
      await fetchSavedQuotes();
    }
    errorMessage = AppLocalizations.of(Get.context!)!.something_went_wrong;
  }

  fetchTags() async {
    tags = await apiRepository.getTags();
    tags.shuffle();
    // selectedTags = [tags[0]];
    filterQuotesByTag();
    reloadState();
  }

  checkForSavedQuotes() {
    for (quote in quotes) {
      if (savedBoxQuotesIds.contains(quote.id)) {
        quote.saved = true;
        reloadState();
      }
    }
  }

  selectTag(Tag tag) async {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
      reloadState();
      // notifyListeners();
    } else {
      selectedTags.remove(tag);
      reloadState();
      // notifyListeners();
    }
    // reloadState();
    await filterQuotesByTag();
  }

  filterQuotes(String query) async {
    if (query.isNotEmpty) {
      selectedTags.clear();
      reloadState();
      debouncing(fn: () async {
        // filteredQuotes.clear();
        changeStatus();

        await Future.microtask(() {
          filteredQuotes = quotes
              .where((element) =>
                  element.content.toLowerCase().contains(query.toLowerCase()))
              .toList();
          changeStatus();
        });
        // reloadState();
      });
    } else {
      filteredQuotes.clear();
      reloadState();
    }
  }

  filterQuotesByTag() async {
    try {
      changeStatus();
      // String tags = selectedTags.map((e) => e.id).toList().join("|");
      List<int> tags = selectedTags.map((e) => e.id).toList();

      filteredQuotes.clear();
      await Future.delayed(const Duration(milliseconds: Constants.kDuration));
      // filteredQuotes = (await apiRepository.getQuotesForTag(tags));

      Future.microtask(() {
        for (quote in quotes) {
          for (int tag in tags) {
            if (quote.tagIds.contains(tag)) {
              filteredQuotes.add(quote);
            }
          }
        }
      });

      ///remove duplicates from filtered quotes
      filteredQuotes = filteredQuotes.toSet().toList();

      // filteredQuotes.shuffle();
      changeStatus();
    } catch (e) {
      debugPrint("$e");
    } finally {
      finishLoading();
    }
  }

  fetchAll({Map<String, dynamic> query = const {}}) async {
    try {
      changeStatus();
      quotes = await apiRepository.getQuotes(query: query);
      quotes.shuffle();

      checkForSavedQuotes();
    } catch (e) {
      debugPrint(e.toString());

      quotes = [];
      tags = [];
      error = true;
    } finally {
      changeStatus();
      finishLoading();
    }
  }

  getQuotesForAuthor(String authorId) async {
    try {
      changeStatus();
      quotes = await apiRepository.getQuotesForAuthor(authorId);
      quotes.shuffle();
    } catch (e) {
      debugPrint(e.toString());

      quotes = [];
      error = true;
    } finally {
      changeStatus();
      finishLoading();
    }
  }

  getRandomQuote({Map<String, dynamic> query = const {}}) async {
    try {
      changeStatus();
      quote = await apiRepository.getRandomQuote(query: query);

      debugPrint("RANDOM QUOTE ${quote.content}");
    } catch (e) {
      debugPrint(e.toString());
      error = true;
    } finally {
      changeStatus();
      finishLoading();
    }
  }

  getSingleQuote(id) async {
    try {
      changeStatus();
      quote = await apiRepository.getSingleQuote(id);
    } catch (e) {
      debugPrint(e.toString());
      error = true;
    } finally {
      changeStatus();
      finishLoading();
    }
  }

  Future<void> shareQuote() async {
    try {
      isSharing = true;
      // reloadState()

      isLoading = true;
      String link =
          await Provider.of<DynamicLinkService>(Get.context!, listen: false)
              .createDynamicLink(quote: selectedQuote);

      finishLoading();
      String shareText =
          '${AppLocalizations.of(Get.context!)!.check_out_this_quote} "${selectedQuote.content}"\n '
          '${AppLocalizations.of(Get.context!)!.on_kophecy}: $link';
      Uint8List? imageFile = await currentScreenshotController.capture(
          delay: const Duration(milliseconds: 50));

      if (isSharing) {
        if (imageFile != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = File("${directory.path}/${quote.id}.png");
          await imagePath.writeAsBytes(imageFile);

          Share.shareFiles(
            [imagePath.path],
            subject: Constants.appName,
            text: shareText,
          );
        } else {
          Share.share(shareText);
        }
      }
      //
      isSharing = false;
    } catch (e) {
      LogUtils.error(e);
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.error_occurred,
        colorText: Colors.white,
      );
    } finally {
      finishLoading();
    }
    // reloadState();
  }

  void selectScreenshotController(ScreenshotController controller) {
    screenshotController = controller;
    reloadState();
  }

  void selectQuote(Quote quote, {bool showDetail = true}) {
    selectedQuote = quote;
    reloadState();

    if (showDetail) {
      Get.bottomSheet(
        /*DraggableScrollableSheet(
        expand: true,
        initialChildSize: .8,
        // maxChildSize: 2,
        minChildSize: .5,
        builder: (BuildContext context, ScrollController scrollController) =>
            SingleChildScrollView(
          controller: scrollController,
          child:*/
        SizedBox(
          height: Get.height,
          child: QuoteDetail(viewModel: this),
        ),
        // ),
        // ),
      );
    }
  }

  void translateQuote(Quote quote) async {
    selectedQuote = quote;
    reloadState();
    try {
      // changeStatus();
      isLoading = true;
      String translatedText = await apiRepository.translateToAppLocale(
        text: quote.content,
        target: defaultLocale ?? "en",
      );

      this.translatedText = translatedText;

      reloadState();
      isLoading = false;

      showTranslateModal(this.translatedText);
      /* int quotePosition = quotes.indexOf(quote);

      quote = quote.copyWith(content: translatedText);

      quotes.replaceRange(quotePosition, quotePosition + 1, [quote]);*/

    } catch (e) {
      debugPrint("translation error: $e");
    } finally {
      // changeStatus();
      finishLoading();
    }
  }

  void bookmark(Quote quote) async {
    try {
      if (!boxQuotes.containsKey(quote.id)) {
        quote = quote.copyWith(saved: true);
        boxQuotes.put(quote.id, quote);
        reloadState();
        isLoading = true;

        await APIRepository.saveQuote(quote.id);
        await fetchSavedQuotes();

        finishLoading();

        Get.snackbar(
          AppLocalizations.of(Get.context!)!.notification,
          AppLocalizations.of(Get.context!)!.quote_added,
        );
      } else {
        unBookmark(quote);
      }
      /*else {
            unBookmark(quote);
          }*/
      reloadState();
    } catch (e) {
      LogUtils.error(e);
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.error_occurred,
        colorText: Colors.white,
      );
    } finally {
      checkForSavedQuotes();
      finishLoading();
    }
  }

  void unBookmark(Quote quote) async {
    try {
      quote = quote.copyWith(saved: false);
      boxQuotes.delete(quote.id);
      reloadState();

      isLoading = true;

      await APIRepository.deleteSavedQuote(quote.id);
      await fetchSavedQuotes();

      finishLoading();

      reloadState();
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.quote_removed,
        colorText: Colors.white,
      );
    } catch (e) {
      LogUtils.error(e);
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        AppLocalizations.of(Get.context!)!.error_occurred,
        colorText: Colors.white,
      );
    } finally {
      finishLoading();
    }
  }

  void showTranslateModal(String translatedText) {
    selectedQuote = selectedQuote.copyWith(content: translatedText);
    reloadState();

    Get.bottomSheet(
      SizedBox(
        height: Get.height * 2,
        child: QuoteDetail(
          viewModel: this,
          userCanTranslate: false,
        ),
      ),
    );

    /*showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Theme.of(Get.context!).backgroundColor.lighten(15),
      context: Get.context!,
      builder: (context) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(20),
        height: 55.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        // alignment: ,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              AppLocalizations.of(context)!.translation_result,
              style: TextStyles.textStyle.apply(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontWeightDelta: 5,
                fontSizeDelta: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              text,
              style: TextStyles.textStyle.apply(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontSizeDelta: 1,
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  fetchSavedQuotes() async {
    try {
      List results = await APIRepository.fetchUserSavedQuotes();

      savedQuotes.clear();

      for (var res in results) {
        //extract uid from res['attributes']['uid'] before the first dot
        String id = res['attributes']['uid'].split(':')[0];

        savedQuotes = [
          ...savedQuotes,
          ...quotes.where((q) => q.id == id.toInt()).toList()
        ];
        reloadState();
      }

      savedQuotes = savedQuotes.reversed.toSet().toList();
      reloadState();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
