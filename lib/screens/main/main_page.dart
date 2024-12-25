import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'components/banner_widget.dart';
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;
  late TabController bottomTabController;
  List<String> timelines = ["Hoy", "Semana", "Mes"];
  String selectedTimeline = "Hoy";
  List<Map<String, String>> chatMessages = [];
  TextEditingController chatController = TextEditingController();

  final List<Product> products = [
    // Llena esta lista con instancias de tu clase Product
    Product(
      id: '1',
      name: 'Producto 1',
      description: 'Descripción del producto 1',
      imageUrls: ['https://via.placeholder.com/150'],
      price: 29.99,
      averageRating: 4.5,
      ratingCount: 100,
    ),
    Product(
      id: '2',
      name: 'Producto 2',
      description: 'Descripción del producto 2',
      imageUrls: ['https://via.placeholder.com/150'],
      price: 49.99,
      averageRating: 4.7,
      ratingCount: 200,
    ),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
  }

  Widget _buildProductList() {
    return ProductList(
      products: products,
    );
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      chatMessages.add({'user': userMessage, 'bot': 'Cargando...'});
    });

    try {
      final responseDoc = await FirebaseFirestore.instance
          .collection('responses')
          .where('input', isEqualTo: userMessage.toLowerCase())
          .limit(1)
          .get();

      String botResponse = responseDoc.docs.isNotEmpty
          ? responseDoc.docs.first['response']
          : 'Lo siento, no entiendo tu mensaje. ¿Podrías reformularlo?';

      setState(() {
        chatMessages.last['bot'] = botResponse;
      });
    } catch (e) {
      setState(() {
        chatMessages.last['bot'] = 'Hubo un error, intenta más tarde.';
      });
    }
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final message = chatMessages[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tú: ${message['user']}"),
                  Text("Bot: ${message['bot']}"),
                ],
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                final userMessage = chatController.text.trim();
                chatController.clear();
                sendMessage(userMessage);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget topHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (var timeline in timelines)
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedTimeline = timeline;
                });
              },
              child: Text(
                timeline,
                style: TextStyle(
                  fontSize: timeline == selectedTimeline ? 20 : 14,
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
      ),
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
                    SliverToBoxAdapter(child: topHeader),
                    SliverToBoxAdapter(child: _buildProductList()),
                    SliverToBoxAdapter(child: tabBar),
                  ];
                },
                body: TabView(tabController: tabController),
              ),
            ),
            CategoryListPage(),
            CheckOutPage(),
            _buildChatInterface(),
          ],
        ),
      ),
    );
  }
}


