import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import 'package:meal_app_improvement/screens/on_boarding_screen.dart';
import './provider/theme_provider.dart';
import './provider/meal_provider.dart';
import './screens/themes_screen.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homeScreen =
      (prefs.getBool("watched") ?? false) ? TabsScreen() : OnBoardingScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MealProvider>(create: (ctx) => MealProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider<LanguageProvider>(
          create: (ctx) => LanguageProvider(),
        )
      ],
      child: MyApp(homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget mainScreen;

  MyApp(this.mainScreen);

  @override
  Widget build(BuildContext context) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    bool useWhiteForeground(Color backgroundColor) =>
        1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: tm,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  headline6: TextStyle(
                      fontSize: 20,
                      color: useWhiteForeground(primaryColor)
                          ? Colors.white
                          : Colors.black,
                      fontFamily: "Raleway")),
              iconTheme: IconThemeData(
                color: useWhiteForeground(primaryColor)
                    ? Colors.white
                    : Colors.black,
              )),
          primarySwatch: primaryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: "Raleway",
          buttonColor: Colors.black87,
          cardColor: Colors.white,
          shadowColor: Colors.black54,
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.black),
              headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: "RobotoCondensed"),
              headline5: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "RobotoCondensed"),
              headline4: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "RobotoCondensed"),
              headline3: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontFamily: "RobotoCondensed"))),
      darkTheme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(14, 22, 33, 1),
          fontFamily: "Raleway",
          buttonColor: Colors.white60,
          unselectedWidgetColor: Colors.white70,
          cardColor: Color.fromRGBO(14, 22, 33, 1),
          shadowColor: Colors.white60,
          textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.white60),
              headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontFamily: "RobotoCondensed"),
              headline5: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "RobotoCondensed"),
              headline4: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "RobotoCondensed"),
              headline3: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: "RobotoCondensed"))),
      routes: {
        "/": (context) => mainScreen,
        CategoryMealsScreen.routeName: (context) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (context) => MealDetailScreen(),
        FiltersScreen.routeName: (context) => FiltersScreen(),
        ThemesScreen.routeName: (context) => ThemesScreen(),
        TabsScreen.routeName: (context) => TabsScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meal App"),
        ),
        body: null);
  }
}
