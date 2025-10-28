import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const CircularProgressIndicator();
            } else if (controller.user.value == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not logged in.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // await controller.signInWithGoogle();
                    },
                    child: const Text('Sign in with Google'),
                  ),
                ],
              );
            } else {
              final user = controller.user.value!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoURL ?? 'https://img.freepik.com/premium-vector/man-profile_1083548-15963.jpg?semt=ais_hybrid&w=740&q=80'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'No Email',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About Us'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    onTap: () {},
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.signOut();
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              );
            }
          }
          ),
        ),
      ),
    );
  }
}
