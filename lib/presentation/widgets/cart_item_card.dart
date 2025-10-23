import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final CartController controller;

  const CartItemCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(

        onTap: () {
          final product = ProductModel(
            id: item.id,
            name: item.name,
            price: item.price,
            imageUrl: item.imageUrl,
            description: '',
          );
          Get.to(() => ProductDetailsView(product: product));
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                width: 100,
                height: 100,
                child: ProductContainer(
                  height: 100,
                  product: ProductModel(
                    id: item.id,
                    name: item.name,
                    price: item.price,
                    imageUrl: item.imageUrl,
                    description: '',
                  ),
                  theme: Theme.of(context),
                ),
              ),

              const SizedBox(width: 16.0),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8.0),

                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: () => controller.decreaseQuantity(item),
                    tooltip: 'Decrease',
                  ),

                  Text(
                    item.quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: () => controller.increaseQuantity(item),
                    tooltip: 'Increase',
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
