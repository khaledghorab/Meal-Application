import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import '../provider/meal_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = "filters";
  final bool fromBoardingScreen;

  FiltersScreen({this.fromBoardingScreen = false});

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: widget.fromBoardingScreen
                  ? null
                  : Text(lan.getTexts("filters_appBar_title")),
              backgroundColor: widget.fromBoardingScreen
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: widget.fromBoardingScreen ? 0 : 5,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.all(20),
                child: Text(lan.getTexts("filters_screen_title"),
                    style: Theme.of(context).textTheme.headline6,textAlign: TextAlign.center),
              ),
              buildSwitchListTile(
                  lan.getTexts("Gluten-free"),
                  lan.getTexts("Gluten-free"),
                  currentFilters["gluten"],
                  (newValue) => setState(() {
                        currentFilters["gluten"] = newValue;
                        Provider.of<MealProvider>(context, listen: false)
                            .setFilters();
                      })),
              buildSwitchListTile(
                  lan.getTexts("Lactose-free"),
                  lan.getTexts("Lactose-free_sub"),
                  currentFilters["lactose"],
                  (newValue) => setState(() {
                        currentFilters["lactose"] = newValue;
                        Provider.of<MealProvider>(context, listen: false)
                            .setFilters();
                      })),
              buildSwitchListTile(
                  lan.getTexts("Vegetarian"),
                  lan.getTexts("Vegetarian-sub"),
                  currentFilters["vegetarian"],
                  (newValue) => setState(() {
                        currentFilters["vegetarian"] = newValue;
                        Provider.of<MealProvider>(context, listen: false)
                            .setFilters();
                      })),
              buildSwitchListTile(
                  lan.getTexts("Vegan"),
                  lan.getTexts("Vegan-sub"),
                  currentFilters["vegan"],
                  (newValue) => setState(() {
                        currentFilters["vegan"] = newValue;
                        Provider.of<MealProvider>(context, listen: false)
                            .setFilters();
                      })),
              SizedBox(
                height: widget.fromBoardingScreen ? 80 : 0,
              )
            ]))
          ],
        ),
        drawer: widget.fromBoardingScreen ? null : MainDrawer(),
      ),
    );
  }

  SwitchListTile buildSwitchListTile(String title, String description,
      bool currentValue, Function updateValue) {
    return SwitchListTile(
        title: Text(title),
        value: currentValue,
        subtitle: Text(description),
        onChanged: updateValue,
        inactiveTrackColor:
            Provider.of<ThemeProvider>(context).tm == ThemeMode.light
                ? null
                : Colors.black);
  }
}
