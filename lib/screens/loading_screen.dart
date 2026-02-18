import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'auth/auth_gate_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      setState(() {
        _progress += 0.012;
      });

      if (_progress >= 1.0) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthGateScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E2D), Color(0xFF101E4C), Color(0xFF2C0F52)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.network(
                  'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonMagenta.withValues(alpha: 0.55),
                            blurRadius: 55,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/logo_icon.png', width: 170, height: 170),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'LUIS FRIO OFICIAL',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2),
                    ),
                    const SizedBox(height: 6),
                    const Text('CARGANDO SISTEMA', style: TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 280,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: LinearProgressIndicator(
                              value: _progress.clamp(0, 1),
                              minHeight: 10,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation(AppTheme.neonCyan),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${(_progress.clamp(0, 1) * 100).toInt()}%',
                            style: const TextStyle(
                              color: AppTheme.neonCyan,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

