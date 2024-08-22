import 'package:ecommerce_int2/models/product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  ProductCard({
    required this.product,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductPage(product: product)),
      ),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xfffbd085).withOpacity(0.46),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: width - 64,
                height: width - 290,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  //fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment(1, 0.5),
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xffe0450a).withOpacity(0.51),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
