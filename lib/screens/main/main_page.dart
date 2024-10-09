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
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/iphone_escarchado.mp4?alt=media&token=a8057861-7758-40ef-8b24-193f02516d66',
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/dise%C3%B1o%20lotso.mp4?alt=media&token=722ecb84-67ee-4fe3-bf75-7a0f5c373d52',
    'https://firebasestorage.googleapis.com/v0/b/flutterecommercetemplate-72969.appspot.com/o/esfera_luz.mp4?alt=media&token=bf2605bc-06c0-428e-8d43-1a66a0020f2d',
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
        ..addListener(() {
          if (_videoController.value.isInitialized && !_videoController.value.isPlaying) {
            // Reproduce solo si está inicializado
            _videoController.play();
          }
        })
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          print('Error al cargar el video: $error');
        });

      _videoController.addListener(() {
        if (_videoController.value.position >= _videoController.value.duration) {
          _playNextVideo(); // Cambia al siguiente video cuando termine
        }
      });
    }


  void _playNextVideo() {
    _videoController.dispose(); // Asegurarse de que el controlador anterior se libere correctamente
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoUrls.length;
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
      tempList.addAll(
          products); // Mostrar todos los productos si no hay consulta
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

        products = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc))
            .toList();

        return isSearching
            ? ProductList(products: searchResults)
            : ProductList(products: products);
      },
    );
  }

  // Construye el widget del reproductor de video
  // Construye el widget del reproductor de video
  Widget _buildVideoPlayer() {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Definir dimensiones dinámicas según el tamaño de la pantalla
    double videoHeight;
    double videoWidth = screenWidth * 0.30
    ; // Ajusta el ancho dinámicamente

    if (screenHeight > 1200) {
      // Pantallas grandes como tablets
      videoHeight = screenHeight * 0.5;
    } else if (screenHeight > 600 && screenHeight <= 1200) {
      // Pantallas medianas como móviles grandes
      videoHeight = screenHeight * 0.4;
    } else {
      // Pantallas pequeñas como móviles compactos
      videoHeight = screenHeight * 0.25;
    }

    return _videoController.value.isInitialized
        ? Center(
      child: Container(
        height: videoHeight,
        width: videoWidth,
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
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
            child: Text(
                timelines[1],
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
            child: Text(
                timelines[2],
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: timelines[2] == selectedTimeline ? 20 : 14,
                    color: Colors.grey)),
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
              height: 24,
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
                headerSliverBuilder: (BuildContext context,
                    bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(child: topHeader),
                    SliverToBoxAdapter(
                      child: _buildVideoPlayer(), // Sin Padding
                    ),
                    SliverToBoxAdapter(child: _buildProductList()),
                    SliverToBoxAdapter(child: tabBar),
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
    );
  }
}