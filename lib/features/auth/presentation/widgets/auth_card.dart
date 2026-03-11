import 'package:flutter/material.dart';
import '../../domain/entities/auth_entity.dart';

class AuthCard extends StatelessWidget {
  final AuthEntity entity;

  const AuthCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entity.name),
        subtitle: Text(entity.id),
      ),
    );
  }
}
