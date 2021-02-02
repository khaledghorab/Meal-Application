import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = "themes_screen";
  final bool fromBoardingScreen;

  ThemesScreen({this.fromBoardingScreen = false});

  Widget buildRadioListTile(
      ThemeMode themeMode, String text, IconData icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(icon, color: Theme.of(ctx).buttonColor),
      value: themeMode,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeMode) =>
          Provider.of<ThemeProvider>(ctx, listen: false)
              .themeModeChange(newThemeMode),
      title: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        drawer: fromBoardingScreen ? null : MainDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: fromBoardingScreen
                  ? null
                  : Text(lan.getTexts("theme_appBar_title")),
              backgroundColor: fromBoardingScreen
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: fromBoardingScreen ? 0 : 5,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.all(20),
                child: Text(lan.getTexts("theme_screen_title"),
                    style: Theme.of(context).textTheme.headline6,textAlign: TextAlign.center),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(lan.getTexts("theme_mode_title"),
                    style: Theme.of(context).textTheme.headline6),
              ),
              buildRadioListTile(ThemeMode.system,
                  lan.getTexts("System_default_theme"), null, context),
              buildRadioListTile(ThemeMode.light, lan.getTexts("light_theme"),
                  Icons.wb_sunny_outlined, context),
              buildRadioListTile(ThemeMode.dark, lan.getTexts("dark_theme"),
                  Icons.nights_stay_outlined, context),
              buildListTile(context, "primary"),
              buildListTile(context, "accent"),
              SizedBox(
                height: fromBoardingScreen ? 80 : 0,
              ),
            ]))
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, String text) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;

    return ListTile(
      title: Text(lan.isEn ? "Choose your $text color" : lan.getTexts("$text")),
      trailing: CircleAvatar(
          backgroundColor: (text == "primary") ? primaryColor : accentColor),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0.0),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: text == "primary"
                        ? Provider.of<ThemeProvider>(context, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(context, listen: true)
                            .accentColor,
                    onColorChanged: (newColor) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .onChanged(newColor, text == "primary" ? 1 : 2),
                    colorPickerWidth: 300.0,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    showLabel: false,
                  ),
                ),
              );
            });
      },
    );
  }
}
