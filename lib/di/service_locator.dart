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

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
}
