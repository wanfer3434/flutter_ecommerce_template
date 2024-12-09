import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/notifications_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page.dart';
import '../../custom_background.dart';
import '../../models/local_product_list.dart';
import '../category/category_list_page.dart';
import '../chat_page.dart';
import 'components/AnotherPage.dart';
import 'components/banner_widget.dart'; // Importa el widget del banner
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';

List<String> timelines = [
  'Destacado Semana',
  'Mejor de Octubre Helloween',
  'Mejor de 2024',
];
String selectedTimeline = 'Presentado Semanalmente';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;
  late TabController bottomTabController;
  List<Product> products = [];
  List<Product> searchResults = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
    products = LocalProductService().getProducts(); // Cargar productos desde el repositorio
  }

  @override
  void dispose() {
    tabController.dispose();
    bottomTabController.dispose();
    super.dispose();
  }

  Widget _buildProductList() {
    return ProductList(
      products: products,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget topHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTimeline = timelines[0];
              });
            },
            child: Text(
              timelines[0],
              style: TextStyle(
                fontSize: timelines[0] == selectedTimeline ? 20 : 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTimeline = timelines[1];
              });
            },
            child: Text(
              timelines[1],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: timelines[1] == selectedTimeline ? 20 : 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTimeline = timelines[2];
              });
            },
            child: Text(
              timelines[2],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: timelines[2] == selectedTimeline ? 20 : 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
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
      unselectedLabelStyle: TextStyle(fontSize: 14.0),
      labelColor: Colors.grey,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
      controller: tabController,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Tienda'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => NotificationsPage()),
              );
            },
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
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 250,
                      pinned: true,
                      primary: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: BannerWidget(
                          imageUrl: 'https://i.imgur.com/GaEsmRG.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnotherPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: topHeader),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildProductList(),
                            SizedBox(height: 16),
                            tabBar,
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabView(tabController: tabController),
              ),
            ),
            CategoryListPage(),
            CheckOutPage(),
            ProfilePage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}