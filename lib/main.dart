import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'blocs/bookmark/bookmark_bloc.dart';
import 'blocs/bookmark/bookmark_event.dart';
import 'blocs/hololive/hololive_bloc.dart';
import 'blocs/hololive/hololive_event.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/hololive_repository.dart';
import 'ui/widgets/live_stream_listener.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              HololiveBloc(HololiveRepository())..add(FetchMembersEvent()),
        ),
        BlocProvider(
          create: (_) => BookmarkBloc()..add(LoadBookmarksEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Hololive Members',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          return LiveStreamListener(child: child!);
        },
        initialRoute: AppRouter.root,
        routes: AppRouter.routes,
      ),
    );
  }
}
