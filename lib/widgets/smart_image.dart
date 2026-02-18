import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SmartImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget img;
    if (source.startsWith('http')) {
      img = Image.network(source, width: width, height: height, fit: fit);
    } else if (source.startsWith('assets/')) {
      img = Image.asset(source, width: width, height: height, fit: fit);
    } else if (!kIsWeb && source.isNotEmpty) {
      img = Image.file(File(source), width: width, height: height, fit: fit);
    } else {
      img = Container(
        width: width,
        height: height,
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}
