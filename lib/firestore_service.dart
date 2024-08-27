import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:firebase_core/firebase_core.dart';

// Función para añadir un producto si no existe
Future<void> addProduct(Product product) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Verifica si ya existe un producto con el mismo nombre
    final querySnapshot = await firestore.collection('products')
        .where('name', isEqualTo: product.name)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Si no existe, añade el producto
      await firestore.collection('products').add(product.toMap());
      print('Producto añadido: ${product.name}');
    } else {
      print('El producto ya existe: ${product.name}');
    }
  } catch (e) {
    print('Error al añadir el producto: $e');
  }
}

// Función para actualizar un producto
Future<void> updateProduct(String documentId, Product product) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('products').doc(documentId).update(product.toMap());
    print('Producto actualizado: ${product.name}');
  } catch (e) {
    print('Error al actualizar el producto: $e');
  }
}

// Función para obtener la lista de productos
Stream<List<Product>> getProducts() {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('products').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc);
    }).toList();
  }).handleError((e) {
    print('Error al obtener los productos: $e');
  });
}

// Función para inicializar los productos si no existen
Future<void> initializeProducts() async {
  await Firebase.initializeApp();

  List<Product> products = [
    Product(
      imageUrl: 'https://media.istockphoto.com/id/487000910/es/foto/multicolor-tel%C3%A9fono-m%C3%B3vil-casos-de-pl%C3%A1stico.jpg?s=1024x1024&w=is&k=20&c=FuQKPwV7Luy3g8S2Oqt_qdMR1XiIv6tNqIctNjY1duU=',
      name: 'Woman Shoes',
      description: 'Shoes with special discount',
      price: 30.0,
    ),
    Product(
      imageUrl: 'https://media.istockphoto.com/id/1394217370/es/foto/fundas-configuradas-para-smartphone-sobre-fondo-blanco-protecci%C3%B3n-de-silicona-para-tel%C3%A9fono.jpg?s=1024x1024&w=is&k=20&c=cAbeVCllOSaeEj8GD0SFhlVksyKPWUKQxew3OgopUzw=',
      name: 'Bag Express',
      description: 'Bag for your shops',
      price: 40.0,
    ),
    Product(
      imageUrl: 'https://media.istockphoto.com/id/1287652193/es/foto/cubierta-transparente-de-pl%C3%A1stico-para-tel%C3%A9fono-m%C3%B3vil-aislada-sobre-fondo-blanco-diferentes.jpg?s=1024x1024&w=is&k=20&c=_KQNUBnAiZpBpnPJ4bvxJUfsQf3aaEOpgUy3Mn4JIo4=',
      name: 'Jeans',
      description: 'Beautiful Jeans',
      price: 102.33,
    ),
    Product(
      imageUrl: 'https://media.istockphoto.com/id/1310474826/es/foto/pila-de-cubiertas-traseras-de-pl%C3%A1stico-multicolor-para-el-tel%C3%A9fono-m%C3%B3vil-elecci%C3%B3n-de.jpg?s=1024x1024&w=is&k=20&c=JyhciwHPWaZxQTo3rxovkJ6fY_oa6_CVNMM-3-_r_g0=',
      name: 'Silver Ring',
      description: 'Description',
      price: 52.33,
    ),
  ];

  for (Product product in products) {
    await addProduct(product);
  }
}
