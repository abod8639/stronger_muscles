import 'package:flutter/material.dart';

// selections shortcuts row
class Selections {
  final String labels;
  final IconData icons;

  Selections({required this.labels, required this.icons});
}

List<Selections> selections = [
  Selections(labels: 'protein', icons: Icons.fitness_center),
  Selections(labels: 'Creatine', icons: Icons.sports_handball),
  Selections(labels: 'amino', icons: Icons.local_drink),
  Selections(labels: 'BCAA', icons: Icons.bolt),
  Selections(labels: 'pre-workout', icons: Icons.flash_on),
  Selections(labels: 'mass gainer', icons: Icons.sports_martial_arts),
];

Padding selectionsRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(6, (index) {

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 8.0,
                ),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withRed(10)
                                    .withAlpha((0.1 * 255).round()),
                                blurRadius: 2.0,
                                blurStyle: BlurStyle.outer,
                                offset: const Offset(1, 2),
                              ),
                            ],
                            color: theme.colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            selections[index].icons,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6.0),
                    SizedBox(
                      width: 70,
                      child: Text(
                        selections[index].labels,
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
        );
      },
    ),
  );
}
