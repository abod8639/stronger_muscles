import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/app_bottom_nav_bar.dart';

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MyBottomNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
