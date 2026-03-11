import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity entity;

  const OrderCard({super.key, required this.entity});

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
