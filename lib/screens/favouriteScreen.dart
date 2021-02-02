import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import '../provider/meal_provider.dart';
import '../widgets/meal_item.dart';
import '../models/meal.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';


class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;

    final List<Meal> favouriteMeals =
        Provider.of<MealProvider>(context, listen: true).favouriteMeals;

    if (favouriteMeals.isEmpty)
      return Center(
          child: Text(lan.getTexts("favorites_text")));
    else {
      return ResponsiveGridList(
          desiredItemWidth:isLandscape ? dw*0.5 : dw,
          minSpacing: 0,
          scroll: true,
          children: favouriteMeals
              .map((meal) => MealItem(
              id: meal.id,
              imageUrl: meal.imageUrl,
              duration: meal.duration,
              complexity: meal.complexity,
              affordability: meal.affordability))
              .toList());
    }
  }
}
