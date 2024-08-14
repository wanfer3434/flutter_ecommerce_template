import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String image;
  final String name;
  final String description;
  final double price;

  Product({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
