
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/buildCheckoutSection.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/cart_item_card.dart';


   const double _listTopSpacing = 10.0;
       final controller = Get.find<CartController>();

/// Builds the cart content with items and checkout section
  Widget buildCartContent() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          children: [
            const SizedBox(height: _listTopSpacing),
        
            // Cart items list
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemCard(item: item);
                },
              ),
            ),
        
            // Divider
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
        
            // Checkout section
            buildCheckoutSection(),
          ],
        );
      }
    );
  }
