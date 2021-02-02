import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../models/category.dart';
import '../models/meal.dart';
import '../dummy_data.dart';

class MealProvider with ChangeNotifier {
  Map<String, bool> filters = {
    "gluten": false,
    "lactose": false,
    "vegan": false,
    "vegetarian": false
  };

  List<Meal> availableMeals = DUMMY_MEALS;

  List<Meal> favouriteMeals = [];

  List<String> prefsMealsId = [];

  List<Category> availableCategory = [];

  void setFilters() async {
    availableMeals = DUMMY_MEALS.where((meal) {
      if (filters["gluten"] && !meal.isGlutenFree) return false;
      if (filters["lactose"] && !meal.isLactoseFree) return false;
      if (filters["vegan"] && !meal.isVegan) return false;
      if (filters["vegetarian"] && !meal.isVegetarian) return false;
      return true;
    }).toList();



    List<Category> ac = [];
    availableMeals.forEach((meal) {
      meal.categories.forEach((catId) {
        DUMMY_CATEGORIES.forEach((cat) {
          if (cat.id == catId) {
            if (!ac.any((cat) => cat.id == catId)) ac.add(cat);
          }
        });
      });
    });
    availableCategory = ac;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("gluten", filters['gluten']);
    prefs.setBool("lactose", filters['lactose']);
    prefs.setBool("vegan", filters['vegan']);
    prefs.setBool("vegetarian", filters['vegetarian']);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filters["gluten"] = prefs.getBool("gluten") ?? false;
    filters["lactose"] = prefs.getBool("lactose") ?? false;
    filters["vegan"] = prefs.getBool("vegan") ?? false;
    filters["vegetarian"] = prefs.getBool("vegetarian") ?? false;
    setFilters();

    prefsMealsId = prefs.getStringList("prefsMealsId") ?? [];
    for (var mealId in prefsMealsId) {
      final existingIndex =
      favouriteMeals.indexWhere((meal) => meal.id == mealId);
      if (existingIndex < 0) {
        favouriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      }
    }

    List<Meal> fm =[];
    favouriteMeals.forEach((favMeals) {
      availableMeals.forEach((avMeals) {
        if(favMeals.id ==avMeals.id) fm.add(favMeals);
      });
    });
    favouriteMeals=fm;
    notifyListeners();
  }

  void toggleFavourite(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingIndex =
    favouriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      favouriteMeals.removeAt(existingIndex);
      prefsMealsId.remove(mealId);
    } else {
      favouriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      prefsMealsId.add(mealId);
    }
    notifyListeners();
    prefs.setStringList("prefsMealsId", prefsMealsId);
  }

  bool isMealFavourite(String id) {
    return favouriteMeals.any((meal) => meal.id == id);
  }
}
