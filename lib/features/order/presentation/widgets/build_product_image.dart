import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';

Widget buildProductImage(String? url) {
  return Builder(
    builder: (context) {
      final isDark = context.isDark;
      return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: AppRadius.allMd,
          color: isDark ? Colors.grey[800] : Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.allMd,
          child: (url != null && url.isNotEmpty)
              ? CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: url,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey[400],
                  ),
                )
              : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
        ),
      );
    },
  );
}
