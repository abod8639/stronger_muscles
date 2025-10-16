
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            // await controller.fetchProducts();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar and filter button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration.collapsed(hintText: 'Search'),
                                  onChanged: controller.onSearchChanged,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
          
                // Shortcuts row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: SizedBox(
                    height: 84,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(6, (index) {
                        final labels = ['protein', 'Creatine', 'amino', 'BCAA','pre-workout','mass gainer'];
                        final icons = [Icons.fitness_center, Icons.sports_handball, Icons.local_drink, Icons.bolt, Icons.flash_on, Icons.sports_martial_arts];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icons[index], color: Colors.pinkAccent),
                              ),
                              const SizedBox(height: 6.0),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  labels[index],
                                  style: const TextStyle(fontSize: 12.0),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
          
                // Promo banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE6F3), Color(0xFFF2E8FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Shop with 100% cashback', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8.0),
                                Text('On Shopee', style: TextStyle(color: Colors.black54)),
                                SizedBox(height: 12.0),
                                SizedBox(
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: null,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(Colors.pinkAccent),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                                    ),
                                    child: Text('I want!'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.headset, size: 72, color: Colors.black12),
                        ),
                      ],
                    ),
                  ),
                ),
          
                // Section title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Most popular offer', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text('See all')),
                    ],
                  ),
                ),
          
                // Horizontal product list
                Obx(() {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return GestureDetector(
                        onTap: () => Get.to(() => ProductDetailsView(product: product)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.0)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: product.id,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: SizedBox(width:24,height:24,child:CircularProgressIndicator())),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6.0),
                                    Text('${product.price.toStringAsFixed(0)}% cashback', style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
