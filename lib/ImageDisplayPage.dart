import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Display'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Failed to load image');
          },
        ),
      ),
    );
  }
}
