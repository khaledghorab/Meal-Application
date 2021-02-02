import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import 'package:meal_app_improvement/provider/theme_provider.dart';
import 'package:meal_app_improvement/screens/filters_screen.dart';
import 'package:meal_app_improvement/screens/tabs_screen.dart';
import 'package:meal_app_improvement/screens/themes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'tabs_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    var primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage("assets/images/image.jpg"),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: 300,
                        color: Theme.of(context).shadowColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Text(
                          lan.getTexts("drawer_name"),
                          style: Theme.of(context).textTheme.headline4,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        )),
                    Container(
                      width: 350,
                      color: Theme.of(context).shadowColor,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(lan.getTexts("drawer_switch_title"),
                              style: Theme.of(context).textTheme.headline5 ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lan.getTexts("drawer_switch_item2"),
                                  style: Theme.of(context).textTheme.headline3),
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
                                },
                              ),
                              Text(lan.getTexts("drawer_switch_item1"),
                                  style: Theme.of(context).textTheme.headline3)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ThemesScreen(fromBoardingScreen: true),
              FiltersScreen(fromBoardingScreen: true),
            ],
            onPageChanged: (val) {
              setState(() {
                _currentIndex = val;
              });
            },
          ),
          Indicator(_currentIndex),
          Builder(
            builder: (ctx) => Align(
              alignment: Alignment(0, 0.85),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: RaisedButton(
                  padding: lan.isEn ? EdgeInsets.all(7) : EdgeInsets.all(0),
                  color: primaryColor,
                  child: Text(
                    lan.getTexts("start"),
                    style: TextStyle(
                      color: useWhiteForeground(primaryColor)
                          ? Colors.white
                          : Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(ctx, TabsScreen.routeName);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("watched", true);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

bool useWhiteForeground(Color backgroundColor) =>
    1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

class Indicator extends StatelessWidget {
  final int index;

  Indicator(this.index);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainer(context, 0),
          buildContainer(context, 1),
          buildContainer(context, 2),
        ],
      ),
    );
  }

  Widget buildContainer(BuildContext ctx, int i) {
    return index == i
        ? Icon(Icons.star, color: Theme.of(ctx).primaryColor)
        : Container(
            margin: EdgeInsets.all(4),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                color: Theme.of(ctx).accentColor, shape: BoxShape.circle),
          );
  }
}
