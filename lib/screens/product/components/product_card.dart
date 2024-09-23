import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double height;
  final double width;

  ProductCard({
    required this.product,
    required this.height,
    required this.width,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double _currentRating = 0; // Para manejar la calificación actual
  int _currentImageIndex = 0; // Índice para manejar la imagen actual
  double _averageRating = 0.0; // Inicializa el promedio de calificación
  int _ratingCount = 0; // Inicializa el conteo de calificaciones

  @override
  void initState() {
    super.initState();
    _loadProductRating(); // Cargar la calificación promedio al iniciar
  }

  // Función para cambiar la imagen cuando se presiona
  void _changeImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % widget.product.imageUrls.length;
    });
  }

  // Función para cargar la calificación promedio desde Firestore
  void _loadProductRating() async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.id) // Usar el id del producto
        .get();

    if (productSnapshot.exists) {
      Map<String, dynamic> data = productSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _averageRating = data['averageRating'] ?? 0.0;
        _ratingCount = data['ratingCount'] ?? 0;
      });
    }
  }

  // Función para guardar la nueva calificación en Firestore
  void _saveRating(double rating) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(widget.product.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(productRef);

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double currentTotalRating = (data['averageRating'] ?? 0.0) * (data['ratingCount'] ?? 0);
        int newRatingCount = (data['ratingCount'] ?? 0) + 1;
        double newAverageRating = (currentTotalRating + rating) / newRatingCount;

        transaction.update(productRef, {
          'averageRating': newAverageRating,
          'ratingCount': newRatingCount,
        });

        setState(() {
          _averageRating = newAverageRating;
          _ratingCount = newRatingCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductPage(product: widget.product)),
      ),
      child: Container(
        height: widget.height,
        width: widget.width - 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagen del producto con cambio de imagen al tocar
            GestureDetector(
              onTap: _changeImage, // Cambia la imagen al tocar
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.25, // Ajuste dinámico
                  child: Image.network(
                    widget.product.imageUrls[_currentImageIndex], // Mostrar la imagen actual
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Información del producto
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Nombre del producto
                  Text(
                    widget.product.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  // Descripción del producto
                  Text(
                    widget.product.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  // Precio del producto
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Widget de calificación con estrellas
                  RatingBar.builder(
                    initialRating: _currentRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0, // Aumenta el tamaño de las estrellas
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _currentRating = rating;
                      });
                      _saveRating(rating); // Guarda la calificación
                    },
                  ),
                  SizedBox(height: 4.0),
                  // Promedio de calificación
                  Text(
                    'Promedio: $_averageRating (${_ratingCount} opiniones)',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
