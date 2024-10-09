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
                height: MediaQuery.of(context).size.height * 0.35, // Ajusta el 30% del alto de la pantalla
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,// Verificar si la lista de imágenes tiene al menos una URL válida
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final category = categories[index];

                    // Verificar si la lista de imágenes tiene al menos una URL válida
                    if (category.imageUrls.isEmpty || category.imageUrls[0].isEmpty) {
                      print('Image URL is missing for category: ${category.name}');
                    }

                    return CategoryCard(
                      controller: AnimationController(
                        vsync: Scaffold.of(context), // Proporciona un vsync adecuado
                        duration: const Duration(milliseconds: 300),
                      ),
                      begin: category.begin,
                      end: category.end,
                      categoryName: category.name ?? 'Unnamed Category',
                      imageUrl: category.imageUrls.isNotEmpty ? category.imageUrls[0] : '',  // Verificar que haya al menos una imagen
                      category: category,
                      description: category.description ?? '',
                      rating: category.averageRating ?? 0.0,
                      whatsappUrl: category.whatsappUrl ?? '',
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 1.0), // Espacio entre la lista de categorías y la lista recomendada
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
