import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          /// 🌗 Dark Mode
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? "Dark Mode Enabled" : "Light Mode Enabled",
                  ),
                ),
              );
            },
          ),

          const Divider(),

          /// 🎨 Theme Info (UI only)
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Theme"),
            subtitle: const Text("Default Purple Theme"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text("Theme"),
                  content: Text(
                    "This app uses a purple-based Material theme.\n"
                    "More themes can be added in future.",
                  ),
                ),
              );
            },
          ),

          const Divider(),

          /// ℹ About App
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text("About"),
                  content: Text(
                    "Hostel / PG Complaint & Mess Feedback App\n"
                    "Version: 1.0\n"
                    "Developed using Flutter",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
