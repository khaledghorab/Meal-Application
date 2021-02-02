import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import '../provider/theme_provider.dart';
import '../provider/meal_provider.dart';
import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favouriteScreen.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "tabScreen";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    Provider.of<MealProvider>(context, listen: false).getData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context, listen: false).getLan();

    super.initState();
  }

  int _selectPage(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
    return _selectedPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    _pages = [
      {"page": CategoriesScreen(), "title": lan.getTexts("categories")},
      {"page": FavouriteScreen(), "title": lan.getTexts("your_favorites")}
    ];
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(_pages[_selectedPageIndex]["title"])),
        body: _pages[_selectedPageIndex]["page"],
        drawer: MainDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor:
              useWhiteForeground(Theme.of(context).primaryColor)
                  ? Colors.black
                  :Provider.of<ThemeProvider>(context).tm==ThemeMode.dark ?Colors.white : Colors.black,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                title: Text(lan.getTexts("categories"))),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
                title: Text(lan.getTexts("your_favorites"))),
          ],
        ),
      ),
    );
  }

  bool useWhiteForeground(Color backgroundColor) =>
      1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;
}
