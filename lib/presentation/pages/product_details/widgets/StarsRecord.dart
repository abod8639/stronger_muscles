import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/ReviewModel.dart';

class StarsRecord extends StatelessWidget {
  final ThemeData theme;
  final List<ReviewModel> reviews;

  const StarsRecord({
    super.key,
    required this.theme,
    required this.reviews,
  });

  /// Calculate average rating from reviews list
  double _calculateAverageRating() {
    if (reviews.isEmpty) return 0.0;
    
    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );
    
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    // Use calculated average rating from reviews
    final averageRating = _calculateAverageRating();
    final actualReviewCount = reviews.length;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          ..._buildStarRating(averageRating),
          const SizedBox(width: 8),
          Text(
            '${averageRating.toStringAsFixed(1)} ($actualReviewCount reviews)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<Icon> _buildStarRating(double stars) {
    final fullStars = stars.floor();
    final hasHalfStar = (stars - fullStars) >= 0.5;
    
    List<Icon> starIcons = [];
    
    // Add full stars
    starIcons.addAll(
      List.generate(
        fullStars,
        (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
      ),
    );
    
    // Add half star if applicable
    if (hasHalfStar && fullStars < 5) {
      starIcons.add(
        const Icon(Icons.star_half_rounded, color: Colors.amber, size: 20),
      );
    }
    
    // Add empty stars
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    starIcons.addAll(
      List.generate(
        emptyStars,
        (index) => const Icon(Icons.star_outline_rounded, color: Colors.grey, size: 20),
      ),
    );
    
    return starIcons;
  }
}
