
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

Widget buildProductImage(String? url) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: url != null
            ? 
            CachedNetworkImage(
              cacheManager: CustomCacheManager.instance ,
              imageUrl: url,
              fit: BoxFit.cover,
            )
            : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
      ),
    );
  }
