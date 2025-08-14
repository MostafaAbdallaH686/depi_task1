import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating; // 0..5
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < full; i++) Icon(Icons.star_rounded, size: size, color: Colors.amber),
        if (hasHalf) Icon(Icons.star_half_rounded, size: size, color: Colors.amber),
        for (int i = 0; i < empty; i++) Icon(Icons.star_border_rounded, size: size, color: Colors.amber),
      ],
    );
  }
}