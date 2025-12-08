
import 'package:flutter/material.dart';

class StarsRecord extends StatelessWidget {
  final ThemeData theme;
  final double? stars;
  final int? reviewCount;

  const StarsRecord({
    super.key,
    required this.theme,
    this.stars,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          ..._buildStarRating(stars ?? 0),
          const SizedBox(width: 8),
          Text(
            '${stars?.toStringAsFixed(1) ?? 'N/A'} (${reviewCount ?? 0} reviews)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

List<Icon> _buildStarRating(double stars) {
  return List.generate(
        stars.floor(),
        (index) => Icon(Icons.star_rounded, color: Colors.amber, size: 20),
      ) +
      List.generate(
        5 - stars.floor(),
        (index) => Icon(Icons.star_rounded, color: Colors.grey, size: 20),
      );
}
}
