import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';

class Selections {
  final String label;
  final IconData icon;

  Selections({required this.label, required this.icon});
}

class SelectionsRow extends StatelessWidget {
  const SelectionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionsController = Get.put(SectionsController());

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
            return Obx(() {
              final isSelected = sectionsController.selectedIndex.value == index;
              return GestureDetector(
                onTap: () {
                  sectionsController.updateIndex(index);
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
            });
          },
        ),
      ),
    );
  }
}
