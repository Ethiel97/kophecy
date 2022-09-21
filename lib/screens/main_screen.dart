import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kophecy/providers/auth_provider.dart';
import 'package:kophecy/providers/navigation_provider.dart';
import 'package:kophecy/providers/theme_provider.dart';
import 'package:kophecy/screens/favorite_quotes_screen.dart';
import 'package:kophecy/screens/quotes_screen.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:kophecy/widgets/w_text_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late NavigationProvider _navigationProvider;
  late ThemeProvider _themeProvider;

  List<Widget> screens = [
    const QuotesScreen(key: ValueKey("quotes")),
    const SearchScreen(key: ValueKey("search")),
    const FavoriteQuotesScreen(key: ValueKey("fav_quotes")),
  ];

  List<BottomNavigationBarItem> navigationBarItems = [
    BottomNavigationBarItem(
      icon: const Icon(
        IconlyBold.home,
      ),
      backgroundColor: Colors.transparent,
      label: AppLocalizations.of(Get.context!)!.home,
    ),
    BottomNavigationBarItem(
      icon: const Icon(
        IconlyBold.search,
      ),
      backgroundColor: Colors.transparent,
      label: AppLocalizations.of(Get.context!)!.search,
    ),
    BottomNavigationBarItem(
      icon: const Icon(
        IconlyBold.bookmark,
      ),
      backgroundColor: Colors.transparent,
      label: AppLocalizations.of(Get.context!)!.saved,
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          // systemNavigationBarColor: Colors.blue, // navigation bar color
          statusBarColor: Theme.of(context).backgroundColor,
        ),
      );
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _themeProvider = Provider.of<ThemeProvider>(context);
  }

  void _onItemTapped(int index) {
    _navigationProvider.currentIndex = index;
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthProvider>(
      builder: (context, authProvider, _) => Scaffold(
            // backgroundColor: screenBackgroundColor,
            backgroundColor: Theme.of(context).backgroundColor,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0.0,
              ),
            ),
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                    top: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 9.w,
                          width: 9.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.circular(Constants.kBorderRadius),
                          ),
                          child: /*Text(
                            Constants.appName.substring(0, 1),
                            style: TextStyles.textStyle.apply(
                              color: Colors.white,
                              fontSizeDelta: 3,
                              fontWeightDelta: 5,
                            ),
                          ),*/
                              const Icon(
                            Iconsax.emoji_happy,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          if (authProvider.status == Status.authenticated) {
                            showAccountModalBottomSheet(context, authProvider);
                          } else {
                            Get.toNamed(login);
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () => _themeProvider.toggleMode(),
                        icon: Icon(
                          _themeProvider.currentTheme == 'dark'
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          size: 8.w,
                        ),
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Center(
                  child: screens.elementAt(_navigationProvider.currentIndex),
                  /*child: IndexedStack(
                    children: screens,
                    index: _navigationProvider.currentIndex,
                  ),*/
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).backgroundColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              enableFeedback: true,
              iconSize: 24,
              items: navigationBarItems,
              currentIndex: _navigationProvider.currentIndex,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              onTap: _onItemTapped,
            ),
          ));

  void showAccountModalBottomSheet(
      BuildContext context, AuthProvider authProvider) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(Constants.kBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 50,
              child: Text(
                authProvider.authUser!.username!.toUpperCase().substring(0, 1),
                style: TextStyles.textStyle.apply(
                    fontWeightDelta: 5,
                    fontSizeDelta: 20,
                    color: Theme.of(context).backgroundColor),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              authProvider.authUser!.username!,
              textAlign: TextAlign.center,
              style: TextStyles.textStyle.apply(
                fontWeightDelta: 5,
                fontSizeDelta: 4,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.user,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Text(
                    authProvider.authUser!.email!,
                    style: TextStyles.textStyle.apply(
                      fontSizeDelta: 2,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Get.back();
                authProvider.confirmLogout();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.kBorderRadius,
                  ),
                ),
                fixedSize: Size(Get.width, 50),
              ),
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyles.textStyle.apply(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSizeDelta: 2,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            WTextButton(
              onPress: () {
                Get.back();
                authProvider.confirmAccountDeletion();
              },
              text: AppLocalizations.of(context)!.delete_account,
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.kBorderRadius),
          topRight: Radius.circular(Constants.kBorderRadius),
        ),
      ),
    );
  }
}
