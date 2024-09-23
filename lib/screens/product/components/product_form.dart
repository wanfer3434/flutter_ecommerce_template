import 'package:flutter/material.dart';
import 'package:ecommerce_int2/firestore_service.dart';
import 'package:ecommerce_int2/models/product.dart';

class ProductForm extends StatefulWidget {
  final String? documentId;
  final Product? existingProduct;

  ProductForm({this.documentId, this.existingProduct});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _imageController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      // Convertir la lista de URLs en una cadena separada por comas
      _imageController.text = widget.existingProduct!.imageUrls.join(', ');
      _nameController.text = widget.existingProduct!.name;
      _descriptionController.text = widget.existingProduct!.description;
      _priceController.text = widget.existingProduct!.price.toString();
    }
  }

  void _submit() async {
    // Convertir el texto ingresado en una lista de URLs
    final imageUrls = _imageController.text.split(',').map((url) => url.trim()).toList();

    // Generar un ID único si es un nuevo producto
    final productId = widget.documentId ?? UniqueKey().toString();  // Puedes usar un método de generación de ID más apropiado

    final product = Product(
      id: productId,  // Agregar el ID aquí
      imageUrls: imageUrls,
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0,
    );

    if (widget.documentId == null) {
      await addProduct(product);
    } else {
      await updateProduct(widget.documentId!, product);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? 'Add Product' : 'Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: 'Image URLs (separated by commas)',
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.documentId == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
