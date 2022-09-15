import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:kophecy/firebase_options.dart';
import 'package:kophecy/main.dart';
import 'package:kophecy/models/author.dart';
import 'package:kophecy/models/tag.dart';

import '../models/quote.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("messaging background...");
  // Or do other work.
}

class Startup {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    _initHiveBox();
    await dotenv.load(fileName: '.env');
  }

  void _initHiveBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuoteAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(AuthorAdapter());
    await Hive.openBox<Quote>(quotesBox);
    await Hive.openBox<Author>(authorsBox);
    await Hive.openBox<Tag>(tagsBox);
  }
}
