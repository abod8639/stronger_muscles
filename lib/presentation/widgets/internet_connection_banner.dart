import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/internet_connection_controller.dart';

class InternetConnectionBanner extends GetView<InternetConnectionController> {
  const InternetConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.red.shade600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 24,
              ),
            ),
            Center(
              child: Expanded(
                child: Text(
                  'No internet connection',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
