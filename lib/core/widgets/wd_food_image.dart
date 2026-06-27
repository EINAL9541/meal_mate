import 'package:flutter/material.dart';

class FoodImageWidget extends StatelessWidget {
  const FoodImageWidget({
    required this.imageId,
    required this.label,
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String imageId;
  final String label;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      imageId.startsWith('http')
          ? imageId
          : 'https://images.unsplash.com/photo-$imageId?w=600&h=450&fit=crop&auto=format',
      width: width,
      height: height,
      fit: BoxFit.cover,
      semanticLabel: label,
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant),
      ),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
