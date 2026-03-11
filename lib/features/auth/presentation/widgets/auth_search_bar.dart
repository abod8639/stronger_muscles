import 'package:flutter/material.dart';

class AuthSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const AuthSearchBar({super.key, this.onChanged});

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
