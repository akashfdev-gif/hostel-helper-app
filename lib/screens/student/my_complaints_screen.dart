import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/app_models.dart';
import '../../utils/extensions.dart';
import '../../widgets/common_widgets.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  @override
  Widget build(BuildContext context) {
    final myIssues = AppData.i.issues
        .where(
          (e) => e.studentName == 'You' || e.studentName.startsWith('Student'),
        )
        .toList();

    return Scaffold( // ✅ FIX: Scaffold added
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: myIssues.length,
          itemBuilder: (context, idx) {
            final it = myIssues[idx];
            return ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComplaintDetailScreen(issueId: it.id),
                ),
              ),
              leading: CircleAvatar(child: Text(it.category[0])),
              title: Text(it.title),
              subtitle: Text('${it.category} • ${it.timestamp.timeAgo()}'),
              trailing: StatusChip(status: it.status),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
      ),
    );
  }
}

class ComplaintDetailScreen extends StatefulWidget {
  final String issueId;
  const ComplaintDetailScreen({super.key, required this.issueId});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  Issue? issue;

  Issue? _findIssue() {
    try {
      return AppData.i.issues.firstWhere((e) => e.id == widget.issueId);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    issue = _findIssue();
  }

  void _refresh() {
    setState(() {
      issue = _findIssue();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (issue == null) {
      return const Scaffold(
        body: Center(child: Text('Issue not found')),
      );
    }

    final data = issue!;

    return Scaffold(
      appBar: AppBar(title: Text(data.title)),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  data.category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                StatusChip(status: data.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('By ${data.studentName} • ${data.timestamp.timeAgo()}'),
            const SizedBox(height: 12),
            Text(data.description),
            const SizedBox(height: 12),
            if (data.imageUrl != null)
              SizedBox(
                height: 160,
                child: Image.network(data.imageUrl!, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            if (data.adminNote != null && data.adminNote!.trim().isNotEmpty)
              ListTile(
                title: const Text('Admin Note'),
                subtitle: Text(data.adminNote!),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => _StudentActionSheet(
                  issue: data,
                  onUpdate: _refresh,
                ),
              ),
              child: const Text('Actions'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentActionSheet extends StatelessWidget {
  final Issue issue;
  final VoidCallback onUpdate;
  const _StudentActionSheet({
    required this.issue,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material( // ✅ Material added
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.thumb_up),
              title: const Text('Mark as resolved (request)'),
              onTap: () {
                final extraNote = 'Student requested resolution';
                final existing = (issue.adminNote ?? '').trim();

                final combinedNote =
                    existing.isEmpty ? extraNote : '$existing\n$extraNote';

                final updated = Issue(
                  id: issue.id,
                  studentName: issue.studentName,
                  title: issue.title,
                  description: issue.description,
                  category: issue.category,
                  priority: issue.priority,
                  status: IssueStatus.InProgress,
                  timestamp: issue.timestamp,
                  imageUrl: issue.imageUrl,
                  adminNote: combinedNote,
                );
                AppData.i.updateIssue(updated);
                onUpdate();
                Navigator.pop(context);
              },
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
