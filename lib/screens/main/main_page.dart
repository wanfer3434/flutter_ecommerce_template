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
import '../chat_page.dart'; // Importamos el ChatScreen
import 'components/AnotherPage.dart';
import 'components/banner_widget.dart'; // Importa el widget del banner
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart'; // Importa el TabView

// Definir las líneas de tiempo
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
  List<Product> products = [];
  TextEditingController chatController = TextEditingController();
  List<Map<String, String>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    products = LocalProductService().getProducts(); // Cargar productos desde el repositorio
  }

  @override
  void dispose() {
    tabController.dispose();
    chatController.dispose();
    super.dispose();
  }

  // Métodos de chat
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      chatMessages.add({'user': userMessage, 'bot': 'Cargando...'}); // Muestra "Cargando..." mientras se obtiene la respuesta
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
        chatMessages.last['bot'] = botResponse; // Actualiza la respuesta del bot
      });
    } catch (e) {
      setState(() {
        chatMessages.last['bot'] = 'Hubo un error, intenta más tarde.'; // En caso de error
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
                sendMessage(userMessage); // Enviar mensaje cuando se presiona el ícono de enviar
              },
            ),
          ],
        ),
      ],
    );
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
              // Navegar a la pantalla del chatbot cuando el ícono es presionado
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()), // Se navega a ChatScreen
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(controller: tabController), // Pasar el controller

      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: tabController,
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
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: _buildChatInterface(),
              ),
            ),
            CategoryListPage(),
            CheckOutPage(),
            ProfilePage(),
            // Agregar el TabView
            TabView(tabController: tabController), // TabView agregado aquí
          ],
        ),
      ),
    );
  }
}
