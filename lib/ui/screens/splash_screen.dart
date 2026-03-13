import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/hololive_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for bloc to finish loading
    final bloc = context.read<HololiveBloc>();

    // Listen until state is no longer loading
    void listener() {
      if (!bloc.isLoading) {
        bloc.removeListener(listener);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/members');
        }
      }
    }

    bloc.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A2E),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00ADB5).withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 50,
                color: Color(0xFF00ADB5),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'hololive',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const Text(
              'production',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF00ADB5),
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(
              color: Color(0xFF00ADB5),
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading members...',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}