import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:firebase_core/firebase_core.dart';

// Función para añadir un producto
Future<void> addProduct(Product product) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('products').add(product.toMap());
    print('Product added: ${product.name}');
  } catch (e) {
    print('Error adding product: $e');
  }
}

// Función para actualizar un producto
Future<void> updateProduct(String documentId, Product product) async {
  final firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('products').doc(documentId).update(product.toMap());
    print('Product updated: ${product.name}');
  } catch (e) {
    print('Error updating product: $e');
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
    print('Error getting products: $e');
  });
}

// Función para inicializar los productos
Future<void> initializeProducts() async {
  await Firebase.initializeApp();

  List<Product> products = [
    Product(
      image: 'https://github.com/wanfer3434/flutter_ecommerce_template/blob/master/assets/Redmi_note_12.png?raw=true',
      name: 'Woman Shoes',
      description: 'Shoes with special discount',
      price: 30,
    ),
    Product(
      image: 'https://github.com/wanfer3434/flutter_ecommerce_template/blob/master/assets/Redmi_13c_5g.png?raw=true',
      name: 'Bag Express',
      description: 'Bag for your shops',
      price: 40,
    ),
    Product(
      image: 'https://github.com/wanfer3434/flutter_ecommerce_template/blob/master/assets/Redmi_Note_10s.jpg?raw=true',
      name: 'Jeans',
      description: 'Beautiful Jeans',
      price: 102.33,
    ),
    Product(
      image: 'https://github.com/wanfer3434/flutter_ecommerce_template/blob/master/assets/a15-silinonna.png?raw=true',
      name: 'Silver Ring',
      description: 'Description',
      price: 52.33,
    ),
    Product(
      image: 'https://github.com/wanfer3434/flutter_ecommerce_template/blob/master/assets/a15-silinonna.png?raw=true',
      name: 'Shoes',
      description: 'Description',
      price: 62.33,
    ),
    Product(
      image: 'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/a15-silinonna.png?alt=media&token=ca1211a9-4ccd-48ae-929f-83960688fab7',
      name: 'Headphones',
      description: 'Description',
      price: 72.33,
    ),
  ];

  for (Product product in products) {
    await addProduct(product);
  }
}
