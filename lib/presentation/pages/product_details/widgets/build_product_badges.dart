import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

Widget buildProductBadges(ProductModel product) {
  final badges = <Widget>[];
  
  if (product.featured) {
    badges.add(_buildBadge('مميز', AppColors.primary));
  }
  
  if (product.newArrival) {
    badges.add(_buildBadge('جديد', Colors.green));
  }
  
  if (product.bestSeller) {
    badges.add(_buildBadge('الأكثر مبيعاً', Colors.orange));
  }
  
  if (badges.isEmpty) return const SizedBox.shrink();
  
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: badges,
  );
}

Widget _buildBadge(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color, width: 1),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
