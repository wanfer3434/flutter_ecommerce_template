import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_card.dart';
import 'recommended_list.dart';
import 'package:ecommerce_int2/screens/category/category_provider.dart';

class TabView extends StatelessWidget {
  final TabController tabController;

  TabView({
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    // Obtén las categorías del CategoryProvider
    final categories = Provider.of<CategoryProvider>(context).categories;

    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: <Widget>[
        // Primer Tab
        Column(
          children: <Widget>[
            // Ajuste dinámico de altura para evitar overflow
            Container(
              margin: EdgeInsets.all(2.0),
              width: MediaQuery.of(context).size.width,
              height: 150.0, // Altura fija para la lista de categorías, ajusta según sea necesario
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final category = categories[index];
                  return CategoryCard(
                    controller: AnimationController(
                      vsync: Scaffold.of(context), // Proporciona un vsync adecuado
                      duration: const Duration(milliseconds: 300),
                    ),
                    begin: category.begin,
                    end: category.end,
                    categoryName: category.category,
                    assetPath: category.image,
                    category: category,
                  );
                },
              ),
            ),
            SizedBox(height:  3.0), // Espacio entre la lista de categorías y la lista recomendada
            Expanded(child: RecommendedList()),
          ],
        ),
        // Otros Tabs (puedes ajustarlos según tus necesidades)
        Column(
          children: <Widget>[
            SizedBox(height: 3.0), // Ajusta el espacio en la parte superior
            Expanded(child: RecommendedList()),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 3.0), // Ajusta el espacio en la parte superior
            Expanded(child: RecommendedList()),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 3.0), // Ajusta el espacio en la parte superior
            Expanded(child: RecommendedList()),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 3.0), // Ajusta el espacio en la parte superior
            Expanded(child: RecommendedList()),
          ],
        ),
      ],
    );
  }
}
