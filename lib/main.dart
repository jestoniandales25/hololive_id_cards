import 'package:flutter/material.dart';
import 'package:hololive_id_cards/blocs/hololive_bloc.dart';
import 'package:hololive_id_cards/data/repositories/hololive_repository.dart';
import 'package:hololive_id_cards/ui/screens/members_screen.dart';
import 'package:hololive_id_cards/ui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 👇 creates bloc AND calls loadMembers() immediately
      create: (_) => HololiveBloc(HololiveRepository())..loadMembers(),
      child: MaterialApp(
        title: 'Hololive Members',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          colorScheme: const ColorScheme.dark(primary: Color(0xFF00ADB5)),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/members': (context) => const MembersScreen(),
        },
      ),
    );
  }
}
