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
    final normalized = source.trim();
    final isWebLocalUrl =
        normalized.startsWith('blob:') ||
        normalized.startsWith('data:') ||
        normalized.startsWith('file:');

    Widget img;
    if (normalized.startsWith('http') || isWebLocalUrl) {
      img = Image.network(
        normalized,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else if (normalized.startsWith('assets/')) {
      img = Image.asset(
        normalized,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else if (!kIsWeb && normalized.isNotEmpty) {
      img = Image.file(
        File(normalized),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else {
      img = _fallback();
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported),
    );
  }
}
