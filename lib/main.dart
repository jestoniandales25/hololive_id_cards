import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toastification/toastification.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/bookmark/bookmark_bloc.dart';
import 'blocs/bookmark/bookmark_event.dart';
import 'blocs/hololive/hololive_bloc.dart';
import 'blocs/hololive/hololive_event.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/app_router.gr.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/hololive_repository.dart';
import 'ui/widgets/live_stream_listener.dart';
import 'blocs/auth/auth_state.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencyInjection();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HololiveRepository>(
          create: (_) => getIt<HololiveRepository>(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (_) => getIt<AuthRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository: getIt<AuthRepository>()),
          ),
          BlocProvider(
            create: (_) =>
                HololiveBloc(getIt<HololiveRepository>())..add(FetchMembersEvent()),
          ),
          BlocProvider(
            create: (_) => BookmarkBloc()..add(LoadBookmarksEvent()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Hololive ID Cards',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter.config(),
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                context.read<BookmarkBloc>().add(LoadBookmarksEvent());
              } else if (state is Unauthenticated) {
                appRouter.replaceAll([const LoginRoute()]);
              }
            },
            child: LiveStreamListener(child: child!),
          );
        },
      ),
    );
  }
}

