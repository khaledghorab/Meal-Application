import 'package:flutter/material.dart';
import 'package:meal_app_improvement/provider/language_provider.dart';
import 'package:meal_app_improvement/provider/meal_provider.dart';
import '../dummy_data.dart';
import 'package:provider/provider.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = "mealDetail";

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

Widget buildSectionTitle(String title, BuildContext ctx) {
  return Container(
    child: Text(title, style: Theme.of(ctx).textTheme.headline6,textAlign: TextAlign.center),
  );
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Widget buildContainer(Widget child) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;

    return Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        height: isLandscape ? dh * 0.5 : dh * 0.25,
        width: isLandscape ? (dw * 0.5 - 30) : dw,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    var accentColor = Theme.of(context).accentColor;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context).settings.arguments as String;
    bool useWhiteForeground(Color backgroundColor) =>
        1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    List<String> stepsLi = lan.getTexts("steps-$mealId") as List<String>;
    var liSteps = ListView.builder(
      padding: EdgeInsets.all(0),
        itemBuilder: (context, index) => Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      "#${index + 1}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    stepsLi[index],
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                if (index < stepsLi.length - 1) Divider(height: 2)
              ],
            ),
        itemCount: stepsLi.length);
    List<String> liIngredientLi =
        lan.getTexts("ingredients-$mealId") as List<String>;
    var liIngredient = ListView.builder(
      padding: EdgeInsets.all(0),
        itemBuilder: (context, index) => Card(
            color: Theme.of(context).accentColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                liIngredientLi[index],
                style: TextStyle(
                  color: useWhiteForeground(accentColor)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            )),
        itemCount: liIngredientLi.length);

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(lan.getTexts("meal-$mealId")),
                background: Container(
                  child: Hero(
                    tag: mealId,
                    child: InteractiveViewer(
                      child: FadeInImage(
                        image: NetworkImage(selectedMeal.imageUrl),
                        fit: BoxFit.cover,
                        placeholder: AssetImage("assets/images/a2.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10),
                if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(
                              lan.isEn
                                  ? "Ingredients"
                                  : lan.getTexts("Ingredients"),
                              context),
                          buildContainer(liIngredient),
                        ],
                      ),
                      Column(
                        children: [
                          buildSectionTitle(
                              lan.isEn ? "Steps" : lan.getTexts("Steps"),
                              context),
                          buildContainer(liSteps)
                        ],
                      )
                    ],
                  ),
                if (!isLandscape)
                  buildSectionTitle(
                      lan.isEn ? "Ingredients" : lan.getTexts("Ingredients"),
                      context),
                if (!isLandscape) buildContainer(liIngredient),
                if (!isLandscape)
                  buildSectionTitle(
                      lan.isEn ? "Steps" : lan.getTexts("Steps"), context),
                if (!isLandscape) buildContainer(liSteps),
              ]),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<MealProvider>(context, listen: false)
              .toggleFavourite(mealId),
          child: Icon(Provider.of<MealProvider>(context, listen: true)
                  .isMealFavourite(mealId)
              ? Icons.star
              : Icons.star_border_outlined),
        ),
      ),
    );
  }
}
