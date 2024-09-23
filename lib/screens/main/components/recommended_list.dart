import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  final List<Product> products = [
    Product(id: '1', imageUrls: ['assets/G54.jpg'], name: 'Bag', description: 'Beautiful bag', price: 2.33),
    Product(id: '2', imageUrls: ['https://media.istockphoto.com/id/1499948872/es/foto/dise%C3%B1o-moderno-de-la-carcasa-del-tel%C3%A9fono-m%C3%B3vil-pegatinas-de-estilo-retro-textura-sobre-fondo.jpg?s=1024x1024&w=is&k=20&c=4S2HV6y8JLix6lzrAxJae7wtX6h6Nlaeq1N4lBfqfys='], name: 'Cap', description: 'Cap with beautiful design', price: 10),
    Product(id: '3', imageUrls: ['https://media.istockphoto.com/id/1348287918/es/foto/fundas-de-silicona-de-colores-para-tel%C3%A9fonos-tecnolog%C3%ADa-actualizada-primer-plano-de-diversos.jpg?s=1024x1024&w=is&k=20&c=EYCb2d_DrSsn-2zeinA79jNRc7V0N6WcOt8-dJIEisI='], name: 'Jeans', description: 'Jeans for you', price: 20),
    Product(id: '4', imageUrls: ['assets/Iphon13_Corazzones.jpg'], name: 'Woman Shoes', description: 'Shoes with special discount', price: 30),
    Product(id: '5', imageUrls: ['assets/Redmi_13c_5g.png'], name: 'Bag Express', description: 'Bag for your shops', price: 40),
    Product(id: '6', imageUrls: ['assets/Redmi_Note_10s.jpg'], name: 'Jeans', description: 'Beautiful Jeans', price: 102.33),
    Product(id: '7', imageUrls: ['assets/Redmi_note_12.png'], name: 'Silver Ring', description: 'Description', price: 52.33),
    Product(id: '8', imageUrls: ['assets/shoeman_7.png'], name: 'Shoes', description: 'Description', price: 62.33),
    Product(id: '9', imageUrls: ['assets/headphone_9.png'], name: 'Headphones', description: 'Description', price: 72.33),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('RecommendedList constraints: $constraints');

        return Column(
          children: <Widget>[
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                      width: 4,
                      color: mediumYellow,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Recomendado',
                      style: TextStyle(
                        color: darkGrey,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: MasonryGridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2,  // Total de columnas en la cuadrícula
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        debugPrint('Product item $index constraints: $constraints');

                        return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ProductPage(product: products[index]),
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.grey.withOpacity(0.3),
                                    Colors.grey.withOpacity(0.7),
                                  ],
                                  center: Alignment(0, 0),
                                  radius: 0.6,
                                  focal: Alignment(0, 0),
                                  focalRadius: 0.1,
                                ),
                              ),
                              child: Hero(
                                tag: products[index].imageUrls[0], // Accede a la primera imagen de la lista
                                child: Image.network(
                                  products[index].imageUrls[0], // Accede a la primera imagen de la lista
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Maneja errores de carga
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
