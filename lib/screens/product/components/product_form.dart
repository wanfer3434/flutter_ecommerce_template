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
      _imageController.text = widget.existingProduct!.imageUrl;
      _nameController.text = widget.existingProduct!.name;
      _descriptionController.text = widget.existingProduct!.description;
      _priceController.text = widget.existingProduct!.price.toString();
    }
  }

  void _submit() async {
    final product = Product(
      imageUrl: _imageController.text,
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
              decoration: InputDecoration(labelText: 'Image URL'),
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
