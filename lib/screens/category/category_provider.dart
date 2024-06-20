import 'package:flutter/material.dart';
import 'package:ecommerce_int2/models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [
    Category(
      Color(0xf4ff0000),
      Color(0xffF68D7F),
      'ABORIGEN',
      'assets/CamisetaAborigenBlancaNegro.jpg',
    ),
    Category(
      Color(0xffF749A2),
      Color(0xffFF7375),
      'Samsung',
      'assets/funda-silicona-suave-samsung-a14-5g-con-camara-3d-7-colores.jpg',
    ),
    Category(
      Color(0xff00E9DA),
      Color(0xff5189EA),
      'Aborigen',
      'assets/CamisetaBlancaAborigen.jpg',
    ),
    Category(
      Color(0xffAF2D68),
      Color(0xff632376),
      'PUNKIS',
      'assets/CamisetaBlancaMangaLargaPunkis.jpg',
    ),
    Category(
      Color(0xff36E892),
      Color(0xff33B2B9),
      'SKATE',
      'assets/CamisetaSkateAllFuckinDayRojaBlanca.jpg',
    ),
    Category(
      Color(0xffF123C4),
      Color(0xff668CEA),
      'Motorola G54',
      'assets/G54.jpg',
    ),
  ];

  List<Category> get categories => _categories;
}
