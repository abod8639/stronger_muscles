import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';

Widget buildProductImage(String? url) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: AppDimens.borderRadiusMd,
      color: Colors.grey[100],
    ),
    child: ClipRRect(
      borderRadius: AppDimens.borderRadiusMd,
      child: url != null
          ? CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: url,
              fit: BoxFit.cover,
            )
          : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
    ),
  );
}
