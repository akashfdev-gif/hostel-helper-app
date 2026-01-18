import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../utils/extensions.dart';

class GreetingCard extends StatelessWidget {
  final String name;
  final DateTime date;
  const GreetingCard({required this.name, required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    final greet =
        'Good ${date.hour < 12 ? 'Morning' : date.hour < 18 ? 'Afternoon' : 'Evening'}';
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(radius: 32, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greet, $name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('How can we help you today?'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SmallTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  RecentActivityCard({super.key});

  final List<String> items = [
    'ISS-101 resolved by admin',
    'Mess menu updated for tomorrow',
    'ISS-103 moved to In Progress',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Recent Activity'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final IssueStatus status;
  const StatusChip({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case IssueStatus.New:
        color = Colors.deepPurple;
        label = 'New';
        break;
      case IssueStatus.InProgress:
        color = Colors.orange;
        label = 'In Progress';
        break;
      case IssueStatus.Resolved:
        color = Colors.green;
        label = 'Resolved';
        break;
    }
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.15),
      avatar: CircleAvatar(backgroundColor: color, child: Text(label[0])),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  const StatCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.indigo.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactsSheet extends StatelessWidget {
  const ContactsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // IMPORTANT: Material wrapper so ListTile has a Material ancestor
      child: Material(
        child: Wrap(
          children: [
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Warden'),
              subtitle: Text('warden@hostel.com'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Mess Manager'),
              subtitle: Text('mess@hostel.com'),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class SegmentedControl<T> extends StatelessWidget {
  final Map<T, Widget> values;
  final T groupValue;
  final ValueChanged<T> onValueChanged;
  const SegmentedControl({
    required this.values,
    required this.groupValue,
    required this.onValueChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.entries.map((e) {
        final active = e.key == groupValue;
        return Expanded(
          child: GestureDetector(
            onTap: () => onValueChanged(e.key),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: e.value),
            ),
          ),
        );
      }).toList(),
    );
  }
}
