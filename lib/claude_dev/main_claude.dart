import 'package:flutter/material.dart';
import 'package:hololive_id_cards/claude_dev/screens/member_detail_screen.dart';
import 'package:hololive_id_cards/claude_dev/screens/members_screen.dart';
import 'package:hololive_id_cards/claude_dev/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'blocs/hololive_bloc.dart';
import 'data/repositories/hololive_repository.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HololiveBloc(HololiveRepository())..loadMembers(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hololive Members',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00ADB5),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/members': (context) => const MembersScreen(),
        '/detail': (context) => const MemberDetailScreen(),  // ← new
      },
    );
  }
}