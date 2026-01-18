import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/auth/login_screen.dart';
import 'screens/student/student_home.dart';
import 'screens/admin/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase init (must)
  await Firebase.initializeApp();

  runApp(const HostelPGApp());
}

class HostelPGApp extends StatefulWidget {
  const HostelPGApp({super.key});

  /// 🔥 Global access for theme change
  static _HostelPGAppState of(BuildContext context) {
    final state =
        context.findAncestorStateOfType<_HostelPGAppState>();
    assert(state != null, 'No HostelPGApp found in context');
    return state!;
  }

  @override
  State<HostelPGApp> createState() => _HostelPGAppState();
}

class _HostelPGAppState extends State<HostelPGApp> {
  ThemeMode _themeMode = ThemeMode.light;

  /// 🌞 / 🌙 Theme switch
  void changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel / PG App',
      debugShowCheckedModeBanner: false,

      // 🌞 Light theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),

      // 🌙 Dark theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),

      themeMode: _themeMode,

      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/student/home': (_) => const StudentHome(),
        '/admin/dashboard': (_) => const AdminDashboard(),
      },
    );
  }
}
