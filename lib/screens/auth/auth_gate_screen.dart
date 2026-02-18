import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'auth_screen.dart';
import '../../services/auth_service.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    if (authService.currentUser != null) {
      return const HomeScreen();
    }

    return const AuthScreen();
  }
}
