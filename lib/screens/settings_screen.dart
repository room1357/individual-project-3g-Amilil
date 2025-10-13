import 'package:flutter/material.dart';

import '../main.dart'; // Akses MyApp.darkModeNotifier
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool _darkMode = MyApp.darkModeNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode, color: Colors.blue),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // 🔥 Ubah dark mode global
              MyApp.darkModeNotifier.value = value;
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text("About"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
