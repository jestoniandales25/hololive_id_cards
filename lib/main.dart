import 'package:flutter/material.dart';
import 'package:hololive_id_cards/pages/dashboard/hololive_page.dart';
import 'package:hololive_id_cards/pages/favorites/favorites_page.dart';
import 'package:hololive_id_cards/providers/hololive_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HololiveProvider(),
      child: const HololiveMainApp(),
    ),
  );
}

class HololiveMainApp extends StatelessWidget {
  const HololiveMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hololive ID Cards',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const HololivePage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
