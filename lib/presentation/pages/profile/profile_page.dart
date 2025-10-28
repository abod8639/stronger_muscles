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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.user.value != null)
                  _buildUserProfile(controller)
                else
                  _buildLoginPrompt(controller),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                _buildSettingsList(),
                const SizedBox(height: 20),
                if (controller.user.value != null)
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.signOut();
                      },
                      child: const Text('Sign out'),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildUserProfile(ProfileController controller) {
    final user = controller.user.value!;
    return Center(
      child: Column(
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
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(ProfileController controller) {
    return Center(
      child: Column(
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
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Theme'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {},
        ),
        const Divider(),
        const SizedBox(height: 10),
        const Text(
          'Support',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
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
      ],
    );
  }
}
