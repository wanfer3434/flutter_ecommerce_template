import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/notifications_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../custom_background.dart';
import '../category/category_list_page.dart';
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';
import 'package:video_player/video_player.dart';

List<String> timelines = [
  'Destacado Semana',
  'Mejor de Julio Día del Padre',
  'Mejor de 2024'
];
String selectedTimeline = 'Presentado Semanalmente';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin<MainPage> {
  late TabController tabController;
  late TabController bottomTabController;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<Product> products = [];
  List<Product> searchResults = [];
  late VideoPlayerController _videoController;
  int _currentVideoIndex = 0;

  // Listado de URLs de los videos
  final List<String> _videoUrls = [
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Forro%20con%20lentes.mp4?alt=media&token=500bfa90-ec9c-4ec1-b739-b17000f07262',
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/Protector%20punta%20de%20cable.mp4?alt=media&token=5de3833b-850d-4116-a007-2d5e80250e3b',
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/iphone_escarchado_proteccion_lentes.mp4?alt=media&token=638f8de4-c7a6-45e4-a18f-1ced8039fb99',
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
    _initializeVideo(_videoUrls[_currentVideoIndex]);
  }

  // Inicializa el controlador de video
  void _initializeVideo(String videoUrl) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _videoController.play(); // Reproduce el video automáticamente
        });
      }).catchError((error) {
        print('Error al cargar el video: $error');
      });

    // Escucha el estado del video y reproduce el siguiente automáticamente
    _videoController.addListener(() {
      if (_videoController.value.isInitialized && !_videoController.value.isPlaying) {
        _videoController.play(); // Reproduce el video si está listo pero no se está reproduciendo
      }
      if (_videoController.value.position == _videoController.value.duration) {
        _playNextVideo(); // Reproduce el siguiente video al finalizar
      }
    });
  }

  // Reproduce el siguiente video en la lista
  void _playNextVideo() {
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoUrls.length; // Repite la lista cuando llega al final
      _initializeVideo(_videoUrls[_currentVideoIndex]);
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
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

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No se encontraron productos.'));
        }

        products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();

        return isSearching
            ? ProductList(products: searchResults)
            : ProductList(products: products);
      },
    );
  }

  // Construye el widget del reproductor de video
  Widget _buildVideoPlayer() {
    return _videoController.value.isInitialized
        ? AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: VideoPlayer(_videoController),
    )
        : Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se inicializa el video
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
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Buscar...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          onChanged: _filterSearchResults,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NotificationsPage()));
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
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: topHeader,
                    ),
                    SliverToBoxAdapter(
                      child: _buildVideoPlayer(), // Agrega el reproductor de video aquí
                    ),
                    SliverToBoxAdapter(
                      child: _buildProductList(),
                    ),
                    SliverToBoxAdapter(
                      child: tabBar,
                    ),
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
