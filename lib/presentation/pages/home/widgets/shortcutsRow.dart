import 'package:flutter/material.dart';

Padding shortcutsRow() {
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
              final labels = [
                'protein',
                'Creatine',
                'amino',
                'BCAA',
                'pre-workout',
                'mass gainer',
              ];
              final icons = [
                Icons.fitness_center,
                Icons.sports_handball,
                Icons.local_drink,
                Icons.bolt,
                Icons.flash_on,
                Icons.sports_martial_arts,
              ];
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withOpacity(0.1),
                                blurRadius: 4.0,
                              ),
                            ],
                            color: theme.colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icons[index],
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
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
        );
      },
    ),
  );
}
