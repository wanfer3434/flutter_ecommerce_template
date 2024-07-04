import 'package:ecommerce_int2/models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Color begin;
  final Color end;
  final String categoryName;
  final String assetPath;
  final Animation<double> controller;

  CategoryCard({
    required this.controller,
    required this.begin,
    required this.end,
    required this.categoryName,
    required this.assetPath,
    required Category category,
  });

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      width: 240.0, // Ancho fijo para la tarjeta
      height: 100.0, // Altura fija para la tarjeta, ajusta según sea necesario
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [begin, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      //padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Imagen con una altura fija
          Container(
            //height: 25.0, // Altura fija para la imagen, ajusta según sea necesario
            width: double.infinity,
            child: Image.asset(
              assetPath,
              //fit: BoxFit.cover, // Ajuste de la imagen
            ),
          ),
          //SizedBox(height: 1.0), // Espacio entre la imagen y el texto
          Text(
            categoryName,
            style: TextStyle(
              fontSize: 8, // Ajusta el tamaño del texto
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              //padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
              child: Text(
                'Ver más',
                style: TextStyle(color: end, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
