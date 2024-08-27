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

    if (categories.isEmpty) {
      // Manejo de caso cuando no hay categorías disponibles
      return Center(child: Text('No categories available'));
    }

    return TabBarView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: tabController,
      children: <Widget>[
        // Primer Tab
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 285.0, // Altura fija para la lista de categorías
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final category = categories[index];

                    // Verificar si la imagen, el nombre y otros detalles están disponibles
                    if (category.image == null || category.image.isEmpty) {
                      print('Image URL is missing for category: ${category.category}');
                    }

                    return CategoryCard(
                      controller: AnimationController(
                        vsync: Scaffold.of(context), // Proporciona un vsync adecuado
                        duration: const Duration(milliseconds: 300),
                      ),
                      begin: category.begin,
                      end: category.end,
                      categoryName: category.category ?? 'Unnamed Category',
                      imageUrl: category.image ?? '', // Asegúrate de que la URL es válida
                      category: category,
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 8.0), // Espacio entre la lista de categorías y la lista recomendada
            ),
            SliverFillRemaining(
              child: RecommendedList(),
            ),
          ],
        ),
        // Otros Tabs con lógica similar...
      ],
    );
  }
}
