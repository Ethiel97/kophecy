import 'dart:io';

import 'package:eventify/eventify.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:kophecy/providers/auth_provider.dart';
import 'package:kophecy/providers/navigation_provider.dart';
import 'package:kophecy/providers/navigator_service.dart';
import 'package:kophecy/providers/notification_service.dart';
import 'package:kophecy/providers/theme_provider.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/startup.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'providers/connectivity_service.dart';
import 'providers/dynamic_link_service.dart';
import 'screens/splash_screen.dart';
import 'utils/app_router.dart';

var quotesBox = 'quotes';
var authorsBox = 'authors';
var tagsBox = 'tags';

void main() async {
  await Startup().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<QuoteViewModel>(
          create: (_) => QuoteViewModel(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        Provider<EventEmitter>(
          create: (_) => EventEmitter(),
        ),
        Provider<DynamicLinkService>(
          create: (_) => DynamicLinkService(),
        ),
        StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.wifi,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConnectivityStatus connectivityStatus;
  late DynamicLinkService _dynamicLinkService;

  @override
  void initState() {
    super.initState();
    initDynamicLinkService();
    initNotificationService();

    /* Future.delayed(Duration.zero, () {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            // systemNavigationBarColor: Colors.blue, // navigation bar color
            statusBarColor: Colors.transparent),
      );
    });*/
  }

  initNotificationService() {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.subscribeToTopic(Constants.dailyRandomQuoteTopic);
    firebaseMessaging.subscribeToTopic(Constants.testTopic);

    NotificationService.setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((event) {
      NotificationService(event).showToast();
    });

    if (Platform.isIOS) {
      firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )
          .then((value) => null)
          .catchError((error) {
        print(error);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    connectivityStatus = Provider.of<ConnectivityStatus>(context);
  }

  initDynamicLinkService() {
    Future.delayed(Duration.zero, () {
      _dynamicLinkService =
          Provider.of<DynamicLinkService>(context, listen: false);

      _dynamicLinkService.handleDynamicLinks().then(
            (value) => print('Ready to handle dynamic links'),
          );
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConnectivityService().notify(connectivityStatus);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => Sizer(
        builder: (context, orientation, deviceType) => OverlaySupport(
          child: GetMaterialApp(
            title: Constants.appName,
            navigatorKey: NavigatorService.navigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme,
            routes: appRoutes,
            home: const SplashScreen(
              key: ValueKey("spash"),
            ),
          ),
        ),
      ),
    );
  }
}
