import 'package:flutter/material.dart';
import 'package:ecommerce_int2/screens/category/category_provider.dart';
import 'package:ecommerce_int2/screens/category/components/staggered_category_card.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoryProvider categoryProvider = CategoryProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemCount: categoryProvider.categories.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categories[index];
            return StaggeredCardCard(
              begin: category.begin,
              end: category.end,
              categoryName: category.category,
              assetPath: category.image,
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CategoriesScreen(),
  ));
}
