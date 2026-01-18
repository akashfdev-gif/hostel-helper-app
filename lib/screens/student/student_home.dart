import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import 'raise_complaint_screen.dart';
import 'my_complaints_screen.dart';
import 'mess_feedback_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/common_widgets.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selected = 0;

  final _pages = const [
    StudentHomeScreen(),
    MyComplaintsScreen(),
    MessFeedbackScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RaiseComplaintScreen()),
            ),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Raise Complaint',
          ),
        ],
      ),
      body: _pages[_selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (i) => setState(() => _selected = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Complaints',
          ),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Mess'),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            label: 'Notifs',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selected == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RaiseComplaintScreen()),
              ),
              label: const Text('Raise'),
              icon: const Icon(Icons.report_problem),
            )
          : null,
    );
  }
}

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GreetingCard(name: 'Akash', date: now),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SmallTile(
                title: 'Raise Complaint',
                subtitle: 'Report issues to warden',
                icon: Icons.report_problem,
                color: Colors.redAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RaiseComplaintScreen(),
                  ),
                ),
              ),
              SmallTile(
                title: 'Mess Feedback',
                subtitle: 'Rate today\'s meals',
                icon: Icons.restaurant,
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MessFeedbackScreen(),
                  ),
                ),
              ),
              SmallTile(
                title: 'My Complaints',
                subtitle: 'Track your requests',
                icon: Icons.history,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyComplaintsScreen(),
                  ),
                ),
              ),
              SmallTile(
                title: 'Contacts',
                subtitle: 'Warden & Helpers',
                icon: Icons.contact_phone,
                color: Colors.teal,
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => const ContactsSheet(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          RecentActivityCard(),
        ],
      ),
    );
  }
}
