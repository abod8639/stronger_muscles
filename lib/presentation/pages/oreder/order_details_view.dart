import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Determine language and theme mode
    final isAr = Get.locale?.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(isAr ? 'تفاصيل الطلب' : 'Order Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Order Status Card
            _buildSection(
              isDark,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'رقم الطلب' : 'Order ID',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${order.id.substring(0, 8)}',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          statusData['text'],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        theme,
                        icon: Icons.calendar_today_outlined,
                        label: isAr ? 'تاريخ الطلب' : 'Date',
                        value: DateFormat('dd MMM yyyy').format(order.orderDate),
                      ),
                      _buildInfoItem(
                        theme,
                        icon: Icons.access_time,
                        label: isAr ? 'الوقت' : 'Time',
                        value: DateFormat('hh:mm a').format(order.orderDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    isAr ? 'المنتجات' : 'Items',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (order.items != null && order.items!.isNotEmpty)
                  ...order.items!.map((item) => _buildOrderItem(item, isDark, isAr, theme)),
              ],
            ),
            const SizedBox(height: 16),

            // Shipping Info
            _buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'معلومات الشحن' : 'Shipping Details',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (order.userName != null) ...[
                    _buildRowInfo(isAr ? 'المستلم' : 'Receiver', order.userName!, theme),
                    const SizedBox(height: 8),
                  ],
                  if (order.phoneNumber != null) ...[
                    _buildRowInfo(isAr ? 'رقم الهاتف' : 'Phone', order.phoneNumber!, theme),
                    const SizedBox(height: 8),
                  ],
                  if (order.shippingAddress != null)
                    _buildRowInfo(isAr ? 'العنوان' : 'Address', order.shippingAddress!, theme),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Summary
            _buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'ملخص الدفع' : 'Payment Summary',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildPriceRow(isAr ? 'المجموع الفرعي' : 'Subtotal', order.subtotal, theme, isAr),
                  _buildPriceRow(isAr ? 'الشحن' : 'Shipping', order.shippingCost, theme, isAr),
                  if (order.discount > 0)
                    _buildPriceRow(isAr ? 'الخصم' : 'Discount', -order.discount, theme, isAr, isDiscount: true),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                  _buildPriceRow(isAr ? 'الإجمالي' : 'Total', order.totalAmount, theme, isAr, isTotal: true),
                ],
              ),
            ),
            
            // Actions (Optional - e.g. Cancel Order)
            if (order.status.toLowerCase() == 'pending') ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                      title: isAr ? 'إلغاء الطلب' : 'Cancel Order',
                      middleText: isAr 
                        ? 'هل أنت متأكد من أنك تريد إلغاء هذا الطلب؟' 
                        : 'Are you sure you want to cancel this order?',
                      textConfirm: isAr ? 'نعم' : 'Yes',
                      textCancel: isAr ? 'لا' : 'No',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        // TODO: Implement cancel order in controller
                        Get.back();
                      },
                    );
                  },
                  child: Text(isAr ? 'إلغاء الطلب' : 'Cancel Order'),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoItem(ThemeData theme, {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10)),
            Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItemModel item, bool isDark, bool isAr, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.imageUrl != null
                  ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.selectedFlavor != null || item.selectedSize != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [item.selectedFlavor, item.selectedSize].where((e) => e != null).join(' | '),
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
             '${item.subtotal.toStringAsFixed(2)} ${isAr ? "ج.م" : "EGP"}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, ThemeData theme, bool isAr, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isTotal ? null : Colors.grey,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} ${isAr ? "ج.م" : "EGP"}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDiscount ? AppColors.success : (isTotal ? AppColors.primary : null),
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status, bool isAr) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': isAr ? 'قيد الانتظار' : 'Pending',
          'color': AppColors.warning,
        };
      case 'processing':
        return {
          'text': isAr ? 'يتم التجهيز' : 'Processing',
          'color': AppColors.primary,
        };
      case 'shipped':
        return {'text': isAr ? 'تم الشحن' : 'Shipped', 'color': Colors.blue};
      case 'delivered':
        return {
          'text': isAr ? 'تم التوصيل' : 'Delivered',
          'color': AppColors.success,
        };
      case 'cancelled':
        return {'text': isAr ? 'ملغي' : 'Cancelled', 'color': AppColors.error};
      default:
        return {'text': status.toUpperCase(), 'color': AppColors.greyDark};
    }
  }
}
