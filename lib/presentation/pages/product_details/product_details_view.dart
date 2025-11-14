import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/image_list_view.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final ScrollController _imageScrollController;
  late final ProductDetailsController _productDetailsController;

  @override
  void initState() {
    super.initState();
    _imageScrollController = ScrollController();
    _productDetailsController = Get.put(ProductDetailsController(widget.product));
  }

  @override
  void dispose() {
    _imageScrollController.dispose();
    Get.delete<ProductDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductContainer(
                onTap:()=>showImageViewer(
                      context,
                      // widget.product.imageUrl.toList(),
                      Image.network(widget.product.imageUrl[_productDetailsController.selectedImageIndex.value]).image,
                      useSafeArea: true,
                      swipeDismissible: true,
                      doubleTapZoomable: true,
                    ),
                height: 350.0,
                product: widget.product,
                theme: theme,
                selectedImageIndex: _productDetailsController.selectedImageIndex,
                onPageChanged: (index) => _productDetailsController.selectImage(index),
              ),
              const SizedBox(height: 24.0),
              Text(
                widget.product.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'LE ${widget.product.price.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16.0),
              ImageListView(
                scrollController: _imageScrollController,
                product: widget.product,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(widget.product.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomIconsRow(widget.product),
    );
  }
}
