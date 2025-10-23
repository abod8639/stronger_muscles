import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/widgets/wishlist_item_card.dart'; // Import the new widget
import 'package:stronger_muscles/core/constants/app_colors.dart'; // Import AppColors for styling

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: AppColors.grey),
                SizedBox(height: 16.0),
                Text(
                  'Your wishlist is empty.',
                  style: TextStyle(fontSize: 18.0, color: AppColors.grey),
                ),
                Text(
                  'Start adding your favorite products!',
                  style: TextStyle(fontSize: 16.0, color: AppColors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final product = controller.wishlistItems[index];
            return WishlistItemCard(product: product, controller: controller);
          },
        );
      }),
    );
  }
}
