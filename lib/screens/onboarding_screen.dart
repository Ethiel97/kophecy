import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/local_storage.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';
import 'package:tinycolor2/tinycolor2.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<IntroScreen> pages = [
    IntroScreen(
      title: AppLocalizations.of(Get.context!)!.daily_fuel,
      imageAsset: 'assets/img/1.png',
      description: AppLocalizations.of(Get.context!)!.sop_everyday,
      headerBgColor: Colors.white,
      textStyle: TextStyles.textStyle,
    ),
    IntroScreen(
      title: AppLocalizations.of(Get.context!)!.strengthen_faith,
      headerBgColor: Colors.white,
      imageAsset: 'assets/img/2.png',
      description: AppLocalizations.of(Get.context!)!.strengthen_faith_description,
      textStyle: TextStyles.textStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  goToNextPage() {
    LocalStorage.setIsFirstLaunch(false);
    Navigator.of(context).pushReplacementNamed(landing);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IntroScreens(
          footerBgColor: TinyColor(AppColors.screenBackgroundColor).color,
          activeDotColor: Colors.white,
          inactiveDotColor: TinyColor(Colors.white).darken(25).color,
          footerRadius: 18.0,
          indicatorType: IndicatorType.CIRCLE,
          slides: pages,
          textColor: Colors.white,
          skipText: AppLocalizations.of(context)!.skip,
          onDone: goToNextPage,
          onSkip: goToNextPage,
        ),
      );
}
