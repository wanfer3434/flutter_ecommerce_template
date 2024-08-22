import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String description;
  final String imageUrl; // Asegúrate de que esta propiedad esté definida
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl, // Asegúrate de que esta propiedad esté definida
    required this.price,
  });

  // Método fromFirestore para crear un producto desde un documento de Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Mapea esto correctamente
      price: (data['price'] is int) ? (data['price'] as int).toDouble() : (data['price'] ?? 0.0),
    );
  }

  // Método toMap para convertir el producto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl, // Mapea esto correctamente
      'price': price,
    };
  }
}
