import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'screens/add_expense_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/shared_expense_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // 🔥 Ini supaya SettingsScreen bisa akses dark mode
  static final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Gunakan ValueListenableBuilder agar tema berubah real-time
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.darkModeNotifier,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Multi-User Expense App',
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          // Halaman pertama
          initialRoute: AppRoutes.login,

          // Daftar semua route
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.expenses: (context) => const ExpenseListScreen(),
            AppRoutes.addExpense: (context) => const AddExpenseScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.sharedExpense: (context) => const SharedExpenseScreen(),
          },
        );
      },
    );
  }
}
