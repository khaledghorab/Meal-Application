import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var primaryColor = Colors.pink;
  var accentColor = Colors.amber;

  var tm = ThemeMode.system;
  String themeText = "s";

  onChanged(newColor, n) async {
    n == 1
        ? primaryColor = _toMaterialColor((newColor.hashCode))
        : accentColor = _toMaterialColor(newColor.hashCode);
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("primaryColor", primaryColor.value);
    preferences.setInt("accentColor", accentColor.value);
  }

  MaterialColor _toMaterialColor(colorVal) {
    return MaterialColor(colorVal, <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(colorVal),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    });
  }

  void themeModeChange(newThemeVal) async {
    tm = newThemeVal;
    _getThemeText(tm);
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("themeText", themeText);
  }

  void _getThemeText(ThemeMode tm) {
    if (tm == ThemeMode.dark)
      themeText = "d";
    else if (tm == ThemeMode.light)
      themeText = "l";
    else if (tm == ThemeMode.system) themeText = "s";
  }

  void getThemeMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    themeText = preferences.getString("themeText") ?? "s";
    if (themeText == "d")
      tm = ThemeMode.dark;
    else if (themeText == "l")
      tm = ThemeMode.light;
    else if (themeText == "s") tm = ThemeMode.system;
    notifyListeners();
  }

  void getThemeColors() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    primaryColor = _toMaterialColor(preferences.getInt("primaryColor")?? 0xFFE91E63) ;
    accentColor = _toMaterialColor(preferences.getInt("accentColor")?? 0xFFFFC107) ;
    notifyListeners();
  }
}
