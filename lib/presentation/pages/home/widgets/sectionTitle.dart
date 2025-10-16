import 'package:flutter/material.dart';

Padding sectionTitle() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Most popular offer',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('See all')),
          ],
        );
      },
    ),
  );
}
