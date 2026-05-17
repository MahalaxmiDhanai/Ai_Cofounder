import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../../services/auth_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCtrl = Get.find<MainController>();
    final authService = Get.put(AuthService());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person, size: 48, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final user = authService.currentUser.value;
            return Column(
              children: [
                Text(user?.displayName ?? 'Guest', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user?.email ?? 'Not signed in', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              ],
            );
          }),
          const SizedBox(height: 32),
          Obx(() => SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme'),
            secondary: Icon(mainCtrl.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
            value: mainCtrl.isDarkMode.value,
            onChanged: (_) => mainCtrl.toggleTheme(),
          )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Idea History'),
            subtitle: const Text('View past analyses'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.snackbar('Coming Soon', 'Idea history will be available soon.'),
          ),
          const Divider(),
          Obx(() {
            final isLoggedIn = authService.currentUser.value != null;
            return ListTile(
              leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
              title: Text(isLoggedIn ? 'Sign Out' : 'Sign In with Google'),
              onTap: () async {
                if (isLoggedIn) {
                  await authService.signOut();
                } else {
                  await authService.signInWithGoogle();
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
