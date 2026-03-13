import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_search_controller.dart';

class ProductSearchsPage extends GetView<ProductSearchController> {
  const ProductSearchsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن المنتجات'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(), // عرض فلاتر الأسعار المختارة
          Expanded(
            child: Obx(() {
              // 1. حالة التحميل
              if (controller.isLoading.value && controller.filteredProducts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. حالة عدم وجود نتائج
              if (controller.filteredProducts.isEmpty) {
                return _buildEmptyState();
              }

              // 3. عرض المنتجات
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
      // زر جانبي لفتح فلاتر الأسعار
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterBottomSheet(context),
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  // شريط البحث
  Widget _buildSearchBar() {
    return TextField(
      controller: controller.textController,
      onChanged: controller.onSearchChanged,
      decoration: InputDecoration(
        hintText: 'ابحث عن منتجك المفضل...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: controller.clearSearch,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // بطاقة المنتج (يمكنك استبدالها ببطاقتك الجاهزة)
  Widget _buildProductCard(dynamic product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50), // استبدلها بصورة المنتج
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.getLocalizedName(), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${product.price} ر.س', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // واجهة الفلترة (Bottom Sheet)
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تصفية حسب السعر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Obx(() => RangeSlider(
                  values: RangeValues(controller.filterMinPrice.value, controller.filterMaxPrice.value),
                  min: controller.dataMinPrice.value,
                  max: controller.dataMaxPrice.value,
                  divisions: 20,
                  labels: RangeLabels('${controller.filterMinPrice.value}', '${controller.filterMaxPrice.value}'),
                  onChanged: (values) {
                    controller.applyPriceFilter(values.start, values.end);
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('تطبيق الفلتر'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد نتائج تطابق بحثك', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      if (controller.searchQuery.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text('نتائج البحث عن: ${controller.searchQuery.value}'),
          onDeleted: controller.clearSearch,
        ),
      );
    });
  }
}