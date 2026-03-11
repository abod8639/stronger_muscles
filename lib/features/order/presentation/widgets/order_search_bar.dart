import 'package:flutter/material.dart';

class OrderSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const OrderSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
