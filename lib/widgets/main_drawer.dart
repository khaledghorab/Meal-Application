import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/theme_provider.dart';
import 'package:meal_app_improvement/screens/tabs_screen.dart';
import '../provider/language_provider.dart';
import '../screens/themes_screen.dart';
import '../screens/filters_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  ListTile buildListTile(
      String text, IconData icon, Function tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(ctx).buttonColor),
      title: Text(
        text,
        style: TextStyle(
            fontSize: 24,
            color: Theme.of(ctx).textTheme.bodyText1.color,
            fontFamily: "RobotoCondensed",
            fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool useWhiteForeground(Color backgroundColor) =>
        1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(20),
                alignment:
                    lan.isEn ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  lan.getTexts("drawer_name"),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 20),
              buildListTile(lan.getTexts("drawer_item1"), Icons.restaurant,
                  () => Navigator.of(context).pushReplacementNamed(TabsScreen.routeName), context),
              buildListTile(
                  lan.getTexts("drawer_item2"),
                  Icons.settings,
                  () => Navigator.of(context)
                      .pushReplacementNamed(FiltersScreen.routeName),
                  context),
              buildListTile(lan.getTexts("drawer_item3"), Icons.color_lens, () {
                Navigator.of(context)
                    .pushReplacementNamed(ThemesScreen.routeName);
              }, context),
              Divider(height: 10, color: Colors.black54),
              Container(
                alignment:
                    lan.isEn ? Alignment.centerLeft : Alignment.centerRight,
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Text(lan.getTexts("drawer_switch_title"),
                    style: Theme.of(context).textTheme.headline6),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    right: lan.isEn ? 0 : 20,
                    left: lan.isEn ? 20 : 0,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(lan.getTexts("drawer_switch_item2"),
                          style: Theme.of(context).textTheme.headline6),
                      Switch(
                        inactiveTrackColor:
                            Provider.of<ThemeProvider>(context).tm ==
                                    ThemeMode.light
                                ? null
                                : Colors.black,
                        value:
                            Provider.of<LanguageProvider>(context, listen: true)
                                .isEn,
                        onChanged: (newValue) {
                          Provider.of<LanguageProvider>(context, listen: false)
                              .changeLan(newValue);
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(lan.getTexts("drawer_switch_item1"),
                          style: Theme.of(context).textTheme.headline6)
                    ],
                  )),
              Divider(height: 10, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
