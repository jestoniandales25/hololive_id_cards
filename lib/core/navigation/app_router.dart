import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';
import 'auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Login route - no guard needed
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),

        // Protected routes
        AutoRoute(
          page: HololiveDashboardRoute.page,
          path: '/',
          initial: true,
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: HololiveDetailRoute.page,
          path: '/detail',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: MemberSongsRoute.page,
          path: '/songs',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: SongPlayerRoute.page,
          path: '/song-player',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: VideoPlayerRoute.page,
          path: '/video-player',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: BookmarkRoute.page,
          path: '/bookmarks',
          guards: [AuthGuard()],
        ),
      ];
}
