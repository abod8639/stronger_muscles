import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileCard extends StatelessWidget {
  final ProfileEntity entity;

  const ProfileCard({super.key, required this.entity});

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
