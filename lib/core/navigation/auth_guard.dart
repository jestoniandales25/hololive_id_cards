import 'package:auto_route/auto_route.dart';
import '../../data/repositories/auth_repository.dart';
import '../di/injection.dart';
import 'app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if the user is authenticated via the AuthRepository
    final authRepository = getIt<AuthRepository>();
    final isAuthenticated = authRepository.currentUser != null;

    if (isAuthenticated) {
      // If authenticated, continue to the requested route
      resolver.next(true);
    } else {
      // If unauthenticated, redirect to the Login screen
      // We use push instead of replace so the user can potentially come back 
      // (though in a simple auth flow, replace is also common)
      router.push(const LoginRoute());
    }
  }
}
