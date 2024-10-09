import 'package:ecommerce_int2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryCard extends StatelessWidget {
  final Color begin;
  final Color end;
  final String categoryName;
  final String imageUrl; // Cambié el nombre de assetPath a imageUrl
  final String description; // Nueva propiedad
  final double rating; // Nueva propiedad
  final String whatsappUrl; // Nueva propiedad
  final Animation<double> controller;

  CategoryCard({
    required this.controller,
    required this.begin,
    required this.end,
    required this.categoryName,
    required this.imageUrl, // Cambié el nombre aquí también
    required this.description,
    required this.rating,
    required this.whatsappUrl,
    required Category category,
  });

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60, // Ajuste dinámico
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [begin, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl, // Imagen desde la URL
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
         // SizedBox(height: 1.0),
          Text(
            categoryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          //SizedBox(height: 1.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          //SizedBox(height: 1.0),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 1.0), // Espacio entre estrella y rating
              Text(
                '$rating',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Spacer(), // Empuja el botón de WhatsApp hacia la derecha
              IconButton(
                icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                onPressed: () async {
                  final Uri whatsappUri = Uri.parse(whatsappUrl);
                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri);
                  } else {
                    throw 'No se puede abrir $whatsappUrl';
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
