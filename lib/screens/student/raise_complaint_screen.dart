import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../data/app_data.dart';
import '../../utils/extensions.dart';

class RaiseComplaintScreen extends StatefulWidget {
  const RaiseComplaintScreen({super.key});

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  String _category = 'Water';
  IssuePriority _priority = IssuePriority.Medium;
  bool _submitting = false;
  String? fakeImage;

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleC.text.trim();
    final desc = _descC.text.trim();
    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill title & description')),
      );
      return;
    }

    setState(() => _submitting = true);

    final id = 'ISS-${Random().nextInt(9999)}';
    final issue = Issue(
      id: id,
      studentName: 'You',
      title: title,
      description: desc,
      category: _category,
      priority: _priority,
      status: IssueStatus.New,
      timestamp: DateTime.now(),
      imageUrl: fakeImage,
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      AppData.i.addIssue(issue);
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted')),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raise Complaint'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              onChanged: (v) => setState(() => _category = v ?? _category),
              items: [
                'Water',
                'WiFi',
                'Light',
                'Cleanliness',
                'Food',
                'Other',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descC,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: IssuePriority.values.map((p) {
                return Expanded(
                  child: RadioListTile<IssuePriority>(
                    value: p,
                    groupValue: _priority,
                    onChanged: (v) =>
                        setState(() => _priority = v ?? _priority),
                    title: Text(p.name.capitalize()),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(
                    () => fakeImage = 'https://via.placeholder.com/300',
                  ),
                  icon: const Icon(Icons.photo),
                  label: const Text('Add Photo (demo)'),
                ),
                const SizedBox(width: 12),
                if (fakeImage != null) const Text('Photo added'),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: _submitting ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Submit Complaint'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
