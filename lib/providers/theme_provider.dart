import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/local_storage.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ThemeProvider with ChangeNotifier {
  final String _themeMode = 'THEME_STATUS';
  String _currentTheme = 'dark';

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: TextStyles.textStyle.fontFamily,
    backgroundColor: AppColors.screenBackgroundColor.darken(),
    scaffoldBackgroundColor: AppColors.screenBackgroundColor.darken(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      bodyText1: TextStyles.textStyle.apply(
        color: Colors.white,
      ),
      bodyText2: TextStyles.textStyle.apply(
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: AppColors.accentColor,
    ),
  );

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: TextStyles.textStyle.fontFamily,
    backgroundColor: AppColors.whiteBackgroundColor.darken(4),
    scaffoldBackgroundColor: AppColors.whiteBackgroundColor,
    primarySwatch: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: AppColors.screenBackgroundColor),
    textTheme: TextTheme(
      bodyText1: TextStyles.textStyle.apply(
        color: AppColors.screenBackgroundColor,
      ),
      bodyText2: TextStyles.textStyle.apply(
        color: AppColors.screenBackgroundColor,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      brightness: Brightness.light,
    ).copyWith(
      secondary: AppColors.accentColor,
    ),
  );

  ThemeData? _themeData;

  ThemeData? get theme => _themeData ?? _darkTheme;

  String get currentTheme => _currentTheme;

  ThemeProvider() {
    LocalStorage.getData(_themeMode).then((value) {
      switch (value?.toString() ?? 'dark') {
        case 'light':
          setLightMode();
          break;
        case 'dark':
          setDarkMode();
          break;
        default:
          setDarkMode();
          break;
      }
      notifyListeners();

      changeStatusBarColor();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void setDarkMode() {
    _themeData = _darkTheme;
    _currentTheme = 'dark';
    LocalStorage.saveData(_themeMode, _currentTheme);
    notifyListeners();
  }

  void toggleMode() {
    if (_currentTheme == 'dark') {
      setLightMode();
    } else {
      setDarkMode();
    }

    changeStatusBarColor();
  }

  void setLightMode() {
    _themeData = _lightTheme;
    _currentTheme = 'light';
    LocalStorage.saveData(_themeMode, _currentTheme);

    notifyListeners();
  }

  changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: currentTheme == 'dark'
            ? AppColors.screenBackgroundColor.darken()
            : AppColors.whiteBackgroundColor.darken(4),
      ),
    );
  }
}
