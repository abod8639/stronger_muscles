import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_list.dart';

class Selections {
  final String label;
  final IconData icon;
  final void Function()? onTap;

  Selections({required this.label, required this.icon, this.onTap});
}

class SelectionsRow extends StatefulWidget {
  // final List<Selections> selections;
  // final int initialIndex;

  const SelectionsRow({
    super.key,
    // required this.selections,
    // this.initialIndex = 0,
  });

  @override
  State<SelectionsRow> createState() => _SelectionsRowState();
}

class _SelectionsRowState extends State<SelectionsRow> {
  late int selectedIndex;
      final SectionsController sectionsController = Get.put(SectionsController());

  @override
  void initState() {
    super.initState();
    selectedIndex = sectionsController.selectedIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sectionsController.selections.length,
          separatorBuilder: (_, index) => const SizedBox(width: 5),
          itemBuilder: (context, index) {
            final item = sectionsController.selections[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                item.onTap?.call();
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainerHighest,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(
                                  (255 * 0.3).round(),
                                )
                              : theme.colorScheme.primary
                                    .withBlue(250)
                                    .withAlpha((255 * 0.3).round()),
                          blurRadius: isSelected ? 6 : 3,
                          offset: const Offset(2, 3),
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  SizedBox(
                    width: 70,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
