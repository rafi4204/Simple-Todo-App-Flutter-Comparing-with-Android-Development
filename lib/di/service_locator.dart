//   fun provideSharedPrefs(): SharedPref│    getIt.registerSingleton(...)
//   @Provides @Singleton               │  }
//   fun provideRepo(p: SharedPref): Repo│
// }                                    │
//
// Then in the Cubit:
//   Android:  @HiltViewModel class MyVM @Inject constructor(repo: Repo)
//   Flutter:  getIt<TodoRepository>()   ← called inside BlocProvider.create

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_repository.dart';

// Global accessor — like Hilt's component, accessed anywhere
final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // ── Singletons ──────────────────────────────────────────────────────────
  // registerSingleton = @Singleton in Hilt — one instance for the app's life

  // SharedPreferences requires async init, so we await it before registering
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // TodoRepository depends on SharedPreferences — get_it resolves it for us
  // Like @Provides fun provideRepo(prefs: SharedPreferences): TodoRepository
  getIt.registerSingleton<TodoRepository>(
    TodoRepository(getIt<SharedPreferences>()),
  );
}
