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
      id: 'redmi_001', // Asegúrate de pasar un 'id' aquí
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Redmi_note_12.png?alt=media&token=c2659260-4655-4a6f-8337-e34997460c5f',
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Redmi_13c_5g.png?alt=media&token=18684a1a-0a65-49e5-9e38-1e1821ebb582'
      ],
      name: 'REDMI',
      description: 'NOTE 12 DISEÑO, Redmi 13c silicona',
      price: 25.000,
    ),
    Product(
      id: 'samsung_001', // Asegúrate de pasar un 'id' aquí
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/silicona.jpeg?alt=media&token=c6dc74de-2e58-4b9a-af31-87488fd7caf4',
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/IMG-20240903-WA0034.jpg?alt=media&token=6aec86e7-cc24-45fd-83c4-23265d7d100c'
      ],
      name: 'Samsung A22',
      description: 'A22 4g,A22 5G',
      price: 30.000,
    ),
    Product(
      id: 'sasung_A15', // Asegúrate de pasar un 'id' aquí
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/a15-silinonna.png?alt=media&token=ca1211a9-4ccd-48ae-929f-83960688fab7',
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/IMG-20240903-WA0039.jpg?alt=media&token=fc649407-14bb-4842-9974-f661c327546f'
      ],
      name: 'Samsung',
      description: 'A21S,A15',
      price: 25.000,
    ),
    Product(
      id: 'samsung_Camara', // Asegúrate de pasar un 'id' aquí
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/front.jpg?alt=media&token=5273ee4f-68b6-4442-940c-53296bbace1c',
        'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/back.jpg?alt=media&token=25f10bf6-be37-40d1-af1e-186ccb1b997d'
      ],
      name: 'Camara Digital',
      description: 'Samsung Camara Digital',
      price: 30.000,
    ),
    // Añade más productos de la misma manera
  ];

  for (Product product in products) {
    await addProduct(product);
  }
}
