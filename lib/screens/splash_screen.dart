import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kophecy/utils/app_router.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/local_storage.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> tA;
  late Animation<double> oA;
  late AnimationController controller;
  bool? firstTime = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2200), vsync: this);
    tA = Tween(begin: -0.12, end: 0.0).animate(
      CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
    );
    oA = Tween(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
    );

    controller.forward();
    startTimeout();
  }

  void goToNextPage() {
    try {
      if (firstTime!) {
        // LocalStorage.setIsFirstLaunch(false);
        Get.offAndToNamed(onBoarding);
      } else {
        Get.offAndToNamed(landing);
      }
    } catch (e) {
      debugPrint("$e");
      // LocalStorage.setIsFirstLaunch(false);
      Get.offAndToNamed(onBoarding);
    }
  }

  void startTimeout() {
    Timer(const Duration(milliseconds: 4500), () => {goToNextPage()});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> checkFirstTime() async => await LocalStorage.getIsFirstLaunch();

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: checkFirstTime(),
        builder: (context, snapshot) {
          firstTime = snapshot.data;

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/splash.webp'),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        tileMode: TileMode.clamp,
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.accentColor.withOpacity(.08),
                          Colors.black.withOpacity(.56)
                        ]),
                  ),
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, widget) {
                    return Center(
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0, tA.value * Get.height, 0),
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: oA,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  height: 15.w,
                                  width: 15.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    Constants.appName.substring(0, 1),
                                    style: TextStyles.textStyle.apply(
                                      color: Colors.white,
                                      fontSizeDelta: 10,
                                      fontWeightDelta: 5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  Constants.appName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              /* SizedBox(
                              height: 3.6.w,
                            ),
                            Image.asset(
                              "assets/img/ico_white.png",
                              fit: BoxFit.cover,
                              height: 110,
                            ),*/
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
}
