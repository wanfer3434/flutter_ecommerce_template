import 'package:flutter/material.dart';
import 'package:ecommerce_int2/models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [
    Category(
      id: 'Redmi',
      begin: Color(0xf4ff0000),
      end:Color(0xffF68D7F),
      name:'Redmi',
      imageUrls:['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Redmi14c.jpg?alt=media&token=a80ff02d-4d96-4828-80d9-0669f4cf8a44'],
      description:'14c,13c', // Descripción
      averageRating: 4.5, // Calificación,
      whatsappUrl:'https://wa.me/1234567890', // WhatsApp UR
    ),
    Category(
      id: 'Iphone',
      begin: Color(0xffF749A2),
      end: Color(0xffFF7375),
      name: 'Iphone',
      imageUrls: ['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/iphone_11_cargaMagnetica.jpg?alt=media&token=503ad888-1f5a-4889-be96-a6dc013f0141'],
      description: '11,12/12 pro,12 pro max,13,14,13promax,14pro,14promax,15', // Descripción
      averageRating: 4.5, // Calificación,
      whatsappUrl: 'https://wa.me/1234567890', // WhatsApp URL
    ),
    Category(
      id: 'Diseños Pines',
      begin: Color(0xff00E9DA),
      end: Color(0xff5189EA),
      name: 'Pines-Diseño-Protección trasera',
      imageUrls: ['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Dise%C3%B1o_Pines_proteci%C3%B3ntrasera.jpg?alt=media&token=5ba472c1-4382-4e26-b9a3-51e50b44347e'],
      description: 'camon20, tecno10c,tecno9pro,note8,note9,note11,note12,note12s,note13pro,note13proplus,A24,A34,S20fe,S21fe,G24,G34,G54 ',
      averageRating: 4.5, // Calificación,
      whatsappUrl: 'https://wa.me/1234567890', // WhatsApp URL
    ),
    Category(
      id: 'Silicone',
      begin:  Color(0xffAF2D68),
      end:  Color(0xff632376),
      name: 'Silicona de Colores',
      imageUrls: ['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/silicona_ReferenciasNuevas.jpg?alt=media&token=6dcc8005-485f-43b1-beb2-643eefc24fe0'],
      description: 'Note11,A05,A05S,A15,A35,A55,HOT40,HOT40PRO,Magig5lite,Magic6lite,Redmi13c,Y9Prime',
      averageRating: 4.5, // Calificación,
      whatsappUrl: 'https://wa.me/1234567890',
    ),
    Category(
      id: 'IphoneD',
      begin: Color(0xff36E892),
      end: Color(0xff33B2B9),
      name: 'Iphone Diamantado',
      imageUrls: ['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/iphone_perlas.jpg?alt=media&token=263aeb05-15b1-411b-bea4-c28b620afb84'],
      description: '11,12,13,14,15',
      averageRating: 4.5, // Calificación,
      whatsappUrl: 'https://wa.me/1234567890',
    ),
    Category(
      id: 'IphoneE',
      begin: Color(0xffF123C4),
      end: Color(0xff668CEA),
      name: 'Iphone Escarchado',
      imageUrls: ['https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/iphone_escarchado.jpg?alt=media&token=fb8c562a-ae29-4e2e-88de-a952e74a8002'],
      description: '11,12,13promax',
      averageRating:  4.5, // Calificación,
      whatsappUrl: 'https://wa.me/1234567890',

    ),
  ];

  List<Category> get categories => _categories;
}
