import 'dart:math'; // لاستخدام دالة min
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';


class BaseDataView<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onSeeAll;
  final int? showCount; // المتغير الذي طلبته

  final int? crossAxisCount;
  final double? mainAxisExtent;
  final double? childAspectRatio;
  final bool useListView;

  const BaseDataView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onSeeAll,
    this.crossAxisCount,
    this.mainAxisExtent,
    this.childAspectRatio,
    this.useListView = false,
    this.showCount,
  });

  // دالة مساعدة لحساب عدد العناصر التي سيتم عرضها فعلياً
  int get _displayCount => showCount != null ? min(showCount!, items.length) : items.length;

  // استخراج العناصر التي سيتم عرضها فقط لضمان الأداء
  List<T> get _displayItems => items.take(_displayCount).toList();

  @override
  Widget build(BuildContext context) {
    // final res = ResponsiveLayout(context);
    
    final int effectiveCrossAxisCount =
        crossAxisCount ?? (1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, ),
        useListView
            ? _buildListView()
            : _buildGridView( effectiveCrossAxisCount,10),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:10,
        //  res.defaultPadding.left,
        vertical: 10,
        // res.defaultPadding.top / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize:10
              //  res.getTitleFontSize(),
            ),
          ),
          // يظهر زر "عرض الكل" فقط إذا كانت هناك دالة وإذا كان هناك عناصر أكثر من المعروضة
          if (onSeeAll != null && (showCount == null || items.length > showCount!))
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize:10,
                  //  res.getBodyFontSize() - 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final displayList = _displayItems;
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        padding: EdgeInsets.symmetric(horizontal: 
        10
        // res.defaultPadding.left
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: itemBuilder(context, displayList[index], index),
        ),
      ),
    );
  }

  Widget _buildGridView( int columns, double spacing) {
    final displayList = _displayItems;
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          // res.defaultPadding.left,
          vertical: spacing / 2,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: mainAxisExtent,
          childAspectRatio: childAspectRatio ?? 10
          // res.getCardAspectRatio(),
        ),
        itemCount: displayList.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, displayList[index], index),
      ),
    );
  }
}