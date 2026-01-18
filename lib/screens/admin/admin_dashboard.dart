import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/app_models.dart';
import '../../utils/extensions.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selected = 0;

  final _pages = const [
    AdminHomeScreen(),
    AdminComplaintsListScreen(),
    FeedbackAnalyticsScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: _pages[_selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (i) => setState(() => _selected = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Complaints'),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Analytics',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = AppData.i.issues.length;
    final pending = AppData.i.issues
        .where(
          (e) =>
              e.status == IssueStatus.New || e.status == IssueStatus.InProgress,
        )
        .length;
    final resolved = AppData.i.issues
        .where((e) => e.status == IssueStatus.Resolved)
        .length;
    final avgRating = AppData.i.feedbacks.isEmpty
        ? 0
        : (AppData.i.feedbacks.map((e) => e.rating).reduce((a, b) => a + b) /
                AppData.i.feedbacks.length)
            .toStringAsFixed(1);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              StatCard(title: 'Total Complaints', value: total.toString()),
              const SizedBox(width: 12),
              StatCard(title: 'Pending', value: pending.toString()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatCard(title: 'Resolved', value: resolved.toString()),
              const SizedBox(width: 12),
              StatCard(title: 'Avg Mess', value: avgRating.toString()),
            ],
          ),
          const SizedBox(height: 18),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Complaints',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppData.i.issues.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final issue = AppData.i.issues[idx];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminComplaintDetailScreen(issueId: issue.id),
                  ),
                ),
                leading: CircleAvatar(child: Text(issue.category[0])),
                title: Text(issue.title),
                subtitle: Text(
                  '${issue.studentName} • ${issue.timestamp.timeAgo()}',
                ),
                trailing: StatusChip(status: issue.status),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AdminComplaintsListScreen extends StatefulWidget {
  const AdminComplaintsListScreen({super.key});

  @override
  State<AdminComplaintsListScreen> createState() =>
      _AdminComplaintsListScreenState();
}

class _AdminComplaintsListScreenState extends State<AdminComplaintsListScreen> {
  IssueStatus? filterStatus;
  String search = '';

  @override
  Widget build(BuildContext context) {
    var list = AppData.i.issues.toList();
    if (filterStatus != null) {
      list = list.where((e) => e.status == filterStatus).toList();
    }
    if (search.isNotEmpty) {
      list = list
          .where(
            (e) =>
                e.title.toLowerCase().contains(search.toLowerCase()) ||
                e.studentName.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search complaints',
                  ),
                  onChanged: (v) => setState(() => search = v),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<IssueStatus?>(
                value: filterStatus,
                onChanged: (v) => setState(() => filterStatus = v),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(
                    value: IssueStatus.New,
                    child: Text('New'),
                  ),
                  DropdownMenuItem(
                    value: IssueStatus.InProgress,
                    child: Text('InProgress'),
                  ),
                  DropdownMenuItem(
                    value: IssueStatus.Resolved,
                    child: Text('Resolved'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final it = list[idx];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminComplaintDetailScreen(issueId: it.id),
                  ),
                ),
                leading: CircleAvatar(child: Text(it.category[0])),
                title: Text(it.title),
                subtitle:
                    Text('${it.studentName} • ${it.timestamp.timeAgo()}'),
                trailing: StatusChip(status: it.status),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AdminComplaintDetailScreen extends StatefulWidget {
  final String issueId;
  const AdminComplaintDetailScreen({super.key, required this.issueId});

  @override
  State<AdminComplaintDetailScreen> createState() =>
      _AdminComplaintDetailScreenState();
}

class _AdminComplaintDetailScreenState
    extends State<AdminComplaintDetailScreen> {
  Issue? issue;
  final _noteC = TextEditingController();
  IssueStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    issue = AppData.i.issues.firstWhere(
      (e) => e.id == widget.issueId,
      orElse: () => null as Issue,
    );
    _selectedStatus = issue?.status;
  }

  void _save() {
    if (issue == null) return;
    final updated = Issue(
      id: issue!.id,
      studentName: issue!.studentName,
      title: issue!.title,
      description: issue!.description,
      category: issue!.category,
      priority: issue!.priority,
      status: _selectedStatus ?? issue!.status,
      timestamp: issue!.timestamp,
      imageUrl: issue!.imageUrl,
      adminNote: _noteC.text.trim().isEmpty
          ? issue!.adminNote
          : _noteC.text.trim(),
    );
    AppData.i.updateIssue(updated);
    setState(() {
      issue = updated;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (issue == null) {
      return const Scaffold(body: Center(child: Text('Issue not found')));
    }
    return Scaffold(
      appBar: AppBar(title: Text('Issue ${issue!.id}')),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              issue!.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${issue!.studentName} • ${issue!.timestamp.timeAgo()}'),
            const SizedBox(height: 12),
            Text(issue!.description),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Status: '),
                const SizedBox(width: 8),
                DropdownButton<IssueStatus>(
                  value: _selectedStatus,
                  onChanged: (v) => setState(() => _selectedStatus = v),
                  items: IssueStatus.values
                      .map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteC,
              decoration: const InputDecoration(
                labelText: 'Admin note (optional)',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: () {
                    setState(() => _selectedStatus = IssueStatus.Resolved);
                    _save();
                  },
                  child: const Text('Mark Resolved'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackAnalyticsScreen extends StatelessWidget {
  const FeedbackAnalyticsScreen({super.key});

  Map<MealType, double> _avgRatings() {
    final Map<MealType, List<int>> map = {};
    for (var f in AppData.i.feedbacks) {
      map.putIfAbsent(f.mealType, () => []).add(f.rating);
    }
    final out = <MealType, double>{};
    for (var k in MealType.values) {
      final list = map[k] ?? [];
      out[k] = list.isEmpty ? 0.0 : list.reduce((a, b) => a + b) / list.length;
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final avg = _avgRatings();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Mess Average Ratings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: MealType.values.map((m) {
              return Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          m.name.capitalize(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          (avg[m] ?? 0.0).toStringAsFixed(1),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            (avg[m] ?? 0).round(),
                            (i) => const Icon(Icons.star, size: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Feedback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: AppData.i.feedbacks.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, idx) {
                final f = AppData.i.feedbacks[idx];
                return ListTile(
                  leading: CircleAvatar(child: Text(f.rating.toString())),
                  title: Text(
                    '${f.studentName} • ${f.mealType.name.capitalize()}',
                  ),
                  subtitle: Text(f.comment ?? '-'),
                  trailing: Text(f.date.timeAgo()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const SizedBox(height: 14),
        const CircleAvatar(
          radius: 42,
          child: Icon(Icons.admin_panel_settings, size: 42),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Hostel Admin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        const Center(child: Text('admin@hostel.com')),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Backup Data'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ],
    );
  }
}
