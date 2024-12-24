import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/notifications_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page.dart';
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
  List<Product> products = [];
  TextEditingController chatController = TextEditingController();
  List<Map<String, String>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    products = LocalProductService().getProducts();
  }

  @override
  void dispose() {
    tabController.dispose();
    chatController.dispose();
    super.dispose();
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

  Widget _buildProductList() {
    return ProductList(
      products: products,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      tabs: [
        Tab(text: 'Explorar'),
        Tab(text: 'Tendencia'),
        Tab(text: 'Deportes'),
        Tab(text: 'Audífonos'),
        Tab(text: 'Inalámbricos'),
      ],
      labelStyle: TextStyle(fontSize: 16.0),
      unselectedLabelStyle: TextStyle(fontSize: 14.0),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
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
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: tabBar.preferredSize,
          child: tabBar,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(controller: tabController),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          // Primera pestaña: Explorar
          SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: BannerWidget(
                      imageUrl: 'https://i.imgur.com/GaEsmRG.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnotherPage()),
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    TabView(tabController: tabController),
                  ]),
                ),
              ],
            ),
          ),

          // Segunda pestaña: Tendencia
          _buildProductList(),

          // Tercera pestaña: Categorías
          CategoryListPage(),

          // Cuarta pestaña: Checkout
          CheckOutPage(),

          // Quinta pestaña: Perfil
          ProfilePage(),
        ],
      ),
    );
  }
}
