import 'package:flutter/material.dart';
import 'package:hololive_id_cards/blocs/hololive_bloc_provider.dart';
import 'package:hololive_id_cards/data/repositories/hololive_repository.dart';
import 'package:hololive_id_cards/ui/screens/hololive_dashboard.dart';
import 'package:hololive_id_cards/ui/screens/member_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HololiveBlocProvider(HololiveRepository())..loadMembers(),
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
        colorScheme: const ColorScheme.dark(primary: Color(0xFF00ADB5)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HololiveDashboard(),
        '/member-detail': (context) => const HololiveDetailScreen(),
      },
    );
  }
}
