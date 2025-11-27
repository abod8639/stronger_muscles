import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

class MainImage extends StatefulWidget {
  final ProductModel product;

  const MainImage({super.key, required this.product});

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  late final PageController _pageController;
  late final ProductDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProductDetailsController>();
    _pageController = PageController(
      initialPage: _controller.selectedImageIndex.value,
    );

    // Listen to controller changes to animate PageView
    ever(_controller.selectedImageIndex, (index) {
      if (_pageController.hasClients && _pageController.page?.round() != index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.product.imageUrl.length,
        onPageChanged: (index) {
          _controller.selectImage(index);
        },
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl[index],
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
