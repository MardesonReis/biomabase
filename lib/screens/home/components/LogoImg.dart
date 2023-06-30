import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LogoImage extends StatelessWidget {
  final String logoUrl;
  final String imageUrl;

  LogoImage({required this.logoUrl, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Card(
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CachedNetworkImage(
                imageUrl: logoUrl,
                width: 48,
                height: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
