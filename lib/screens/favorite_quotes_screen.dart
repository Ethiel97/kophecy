import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kophecy/providers/theme_provider.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:kophecy/views/base_view.dart';
import 'package:kophecy/widgets/w_quote_card.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FavoriteQuotesScreen extends StatefulWidget {
  const FavoriteQuotesScreen({required Key key}) : super(key: key);

  @override
  State<FavoriteQuotesScreen> createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  @override
  Widget build(BuildContext context) => BaseView<QuoteViewModel>(
        key: UniqueKey(),
        vmBuilder: (context) => Provider.of<QuoteViewModel>(context),
        builder: _buildScreen,
      );

  Widget _buildScreen(BuildContext context, QuoteViewModel quoteViewModel) =>
      Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Jiffy().yMMMEd.toString(),
                      style: TextStyles.textStyle.apply(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(
                              .5,
                            ),
                        fontSizeDelta: -4,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.favorite_quote,
                      style: TextStyles.textStyle.apply(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontWeightDelta: 5,
                        fontSizeDelta: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              quoteViewModel.savedQuotes.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Image.asset(
                            "assets/img/empty-${themeProvider.currentTheme}.png",
                            height: 40.h,
                            width: 100.w,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            AppLocalizations.of(context)!.no_saved_quotes,
                            textAlign: TextAlign.center,
                            style: TextStyles.textStyle.apply(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 64.h,
                      width: 100.w,
                      child: PageView.builder(
                        pageSnapping: true,
                        controller: PageController(viewportFraction: .8),
                        itemCount: quoteViewModel.savedQuotes.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(
                            right: 18.0,
                          ),
                          child: WQuoteCard(
                            key: UniqueKey(),
                            quote: quoteViewModel.savedQuotes[index],
                            viewModel: quoteViewModel,
                            onTranslate: () => {},
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
}
