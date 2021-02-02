import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import 'package:meal_app_improvement/provider/meal_provider.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = "category_meals";

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Meal> displayedMeals;
  String categoryId;
  @override
  void didChangeDependencies() {
    final List<Meal> availableMeals =
        Provider.of<MealProvider>(context, listen: true).availableMeals;

    final routeArg =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    categoryId = routeArg["id"];
    displayedMeals = availableMeals
        .where((meal) => meal.categories.contains(categoryId))
        .toList();
    super.didChangeDependencies();
  }

  void removeMeal(String mealId) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(lan.getTexts("cat-$categoryId"),)),
        body: ResponsiveGridList(
            desiredItemWidth:isLandscape ? dw*0.5 : dw,
            minSpacing: 0,
            children: displayedMeals
                .map((meal) => MealItem(
                id: meal.id,
                imageUrl: meal.imageUrl,
                duration: meal.duration,
                complexity: meal.complexity,
                affordability: meal.affordability))
                .toList()),
      ),
    );
  }
}
