import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import '../provider/meal_provider.dart';
import '../widgets/category_item.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body:  GridView(
            padding: EdgeInsets.all(25),
            children: Provider.of<MealProvider>(context)
                .availableCategory
                .map(
                  (categoryData) => CategoryItem(
                      categoryData.id, categoryData.color),
                )
                .toList(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 4 / 2.9,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
          ),
        ),

    );
  }
}
