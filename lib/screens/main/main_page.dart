import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/notifications_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page.dart';

import '../../custom_background.dart';
import '../category/category_list_page.dart';
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';

List<String> timelines = [
  'Destacado Semana',
  'Mejor de Julio Día del Padre',
  'Mejor de 2024'
];
String selectedTimeline = 'Presentado Semanalmente';

List<Product> products = [
  Product(
      'assets/Redmi_note_12.png',
      'Redmi Note12 Diseño Dama',
      'Funda de Teléfono TPU para la serie Xiaomi Redmi con diseños creativos de parejas-Proteccion duradera para 10/10A/10C/12/12C/13C/Note10/Note10s/Pro/Max/Note11/Note11S/Pro/Note12/Note12s/Pro/5G/Note13/Note135G/Pro/13Pro5G.',
      35999),
  Product(
      'assets/a15-silinonna.png',
      'Samsung A15',
      'Estuche para Telefono con Espejo de Mariposa regalo para San Valentin/Pacua/Niña/Novios, para iphone14 /14Plus/14Pro Ma, iPHONE13/13mini/13Pro MaxIphone12/12Mini/12Pro,12Pro max',
      25999),
  Product(
      'assets/Iphone11_mariposa.jpg',
      'iphone 11',
      'Estuche Para Teléfono con Espejo de Mariposa Regalo Para San Valentín/Pascua/Niña/Novios,Para Iphone 14 / 14Plus/14Pro/14ProMax,Iphone13/13Mini/13Pro/13ProMax/Iphone12/12Mini/12Pro/12ProMax,Iphone11/11Pro/11ProMax.',
      20999),
];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  late TabController tabController;
  late TabController bottomTabController;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<Product> searchResults = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
    searchResults.addAll(products);
  }

  void _filterSearchResults(String query) {
    List<Product> tempList = [];
    if (query.isNotEmpty) {
      products.forEach((product) {
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(product);
        }
      });
    } else {
      tempList.addAll(products); // Mostrar todos los productos si no hay consulta
    }
    setState(() {
      searchResults.clear();
      searchResults.addAll(tempList);
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        _filterSearchResults('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget topHeader = Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTimeline = timelines[0];
                  // Actualizar productos según la línea de tiempo seleccionada
                });
              },
              child: Text(
                timelines[0],
                style: TextStyle(
                    fontSize: timelines[0] == selectedTimeline ? 20 : 14,
                    color: Colors.grey),
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTimeline = timelines[1];
                  // Actualizar productos según la línea de tiempo seleccionada
                });
              },
              child: Text(timelines[1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: timelines[1] == selectedTimeline ? 20 : 14,
                      color: Colors.grey)),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTimeline = timelines[2];
                  // Actualizar productos según la línea de tiempo seleccionada
                });
              },
              child: Text(timelines[2],
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: timelines[2] == selectedTimeline ? 20 : 14,
                      color: Colors.grey)),
            ),
          ),
        ],
      ),
    );

    Widget tabBar = TabBar(
      tabs: [
        Tab(text: 'Tendencia'),
        Tab(text: 'Deportes'),
        Tab(text: 'Audífonos'),
        Tab(text: 'Inalámbricos'),
        Tab(text: 'Bluetooth'),
      ],
      labelStyle: TextStyle(fontSize: 16.0),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0,
      ),
      labelColor: Colors.grey,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
      controller: tabController,
    );

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Tu Tienda')
            : TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Buscar...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _filterSearchResults,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsPage()));
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search_icon.svg',
              height: 24, // Ajustar según el tamaño de tu icono
              width: 24,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // Estos son los slivers que aparecen en el "outer" scroll view.
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: topHeader,
                    ),
                    SliverToBoxAdapter(
                      child: isSearching
                          ? ProductList(products: searchResults)
                          : ProductList(products: products),
                    ),
                    SliverToBoxAdapter(
                      child: tabBar,
                    )
                  ];
                },
                body: TabView(
                  tabController: tabController,
                ),
              ),
            ),
            CategoryListPage(),
            CheckOutPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
