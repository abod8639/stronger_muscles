import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


// Pre-cache images

class ImagePrecacheService {
  static Future<void> cacheImages(BuildContext context, List<String> urls) async {
    for (final url in urls) {
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }
}