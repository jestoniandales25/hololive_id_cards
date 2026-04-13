import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/hololive_repository.dart';
import '../navigation/app_router.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<HololiveRepository>(() => HololiveRepository());

  // Router
  getIt.registerSingleton<AppRouter>(AppRouter());
}
