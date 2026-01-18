import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../data/app_data.dart';
import '../../utils/extensions.dart';
import '../../widgets/common_widgets.dart';

class MessFeedbackScreen extends StatefulWidget {
  const MessFeedbackScreen({super.key});

  @override
  State<MessFeedbackScreen> createState() => _MessFeedbackScreenState();
}

class _MessFeedbackScreenState extends State<MessFeedbackScreen> {
  MealType _meal = MealType.Breakfast;
  int _rating = 5;
  final _commentC = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentC.dispose();
    super.dispose();
  }

  void _submit() {
    final comment = _commentC.text.trim();

    setState(() => _submitting = true);

    final f = FeedbackItem(
      id: 'FB-${Random().nextInt(9999)}',
      studentName: 'You',
      mealType: _meal,
      rating: _rating,
      comment: comment.isEmpty ? null : comment,
      date: DateTime.now(),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      AppData.i.addFeedback(f);
      setState(() {
        _submitting = false;
        _rating = 5;
        _commentC.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbacks = AppData.i.feedbacks;

    return Scaffold( // ✅ FIX
      appBar: AppBar(
        title: const Text('Mess Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SegmentedControl<MealType>(
              values: {
                MealType.Breakfast: const Icon(Icons.sunny),
                MealType.Lunch: const Icon(Icons.lunch_dining),
                MealType.Dinner: const Icon(Icons.nightlight_round),
              },
              groupValue: _meal,
              onValueChanged: (v) => setState(() => _meal = v),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rate (1–5):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final val = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = val),
                  icon: Icon(
                    val <= _rating ? Icons.star : Icons.star_border,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentC,
              decoration: const InputDecoration(
                labelText: 'Comment (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Submit Feedback'),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: feedbacks.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final fb = feedbacks[idx];
                  return ListTile(
                    leading: CircleAvatar(child: Text(fb.rating.toString())),
                    title: Text(
                      '${fb.studentName} • ${fb.mealType.name.capitalize()}',
                    ),
                    subtitle: Text(fb.comment ?? '-'),
                    trailing: Text(fb.date.timeAgo()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
