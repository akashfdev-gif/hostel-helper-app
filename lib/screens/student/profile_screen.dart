import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const SizedBox(height: 12),
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Akash Verma',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        const Center(child: Text('akash@example.com')),
        const SizedBox(height: 20),

        /// ⚙ Settings
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
        ),

        /// 🚪 Logout
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ],
    );
  }
}
