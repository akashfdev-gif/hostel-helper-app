import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Your complaint ISS-101 is now In Progress',
      'New notice: Mess will be closed on Sunday',
      'Admin replied to your complaint ISS-103',
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, idx) {
        return ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(items[idx]),
          subtitle: const Text('Just now'),
        );
      },
    );
  }
}
