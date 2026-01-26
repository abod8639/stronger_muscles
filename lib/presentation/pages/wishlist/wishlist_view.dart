import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/widget/wishlist_item_card.dart'; // Import the new widget
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart'; // Import AppColors for styling

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishlistController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.wishlist,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: AppColors.grey,
                ),
                const SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context)!.yourWishlistIsEmpty,
                  style: const TextStyle(fontSize: 18.0, color: AppColors.grey),
                ),
                Text(
                  AppLocalizations.of(context)!.startAddingFavorites,
                  style: const TextStyle(fontSize: 16.0, color: AppColors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final product = controller.wishlistItems[index];
            return WishlistItemCard(product: product);
          },
        );
      }),
    );
  }
}
