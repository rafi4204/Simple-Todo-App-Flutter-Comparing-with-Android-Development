# 📝 Todo App — Flutter BlocProvider + get_it

📱 Flutter Todo App — An Android Developer's Guide to Flutter

A hands-on Flutter project designed specifically for Android developers making the jump to Flutter. Instead of learning Flutter from scratch, every concept is mapped to what you already know.

Built with:
• 🧠 Cubit (flutter_bloc) — your ViewModel, but simpler
• 🔌 get_it — your Hilt, without the annotation processing
• 💾 SharedPreferences — identical API to Android
• 🏗️ Clean Architecture — same Repository pattern you know

Android → Flutter at a glance:
ViewModel → Cubit | StateFlow → BlocBuilder | Hilt @Module → service_locator.dart | data class copy() → copyWith() | RecyclerView → ListView.builder | BottomSheetDialogFragment → showModalBottomSheet

If you've shipped Android apps, you'll be productive in Flutter within a day.
---

## 📁 Project Structure

```
todo_bloc_app/
│
├── pubspec.yaml                        # Dependencies
│
└── lib/
    │
    ├── main.dart                       # App entry point — await setupLocator() then runApp()
    │
    ├── di/
    │   └── service_locator.dart        # get_it setup — registers all singletons
    │
    ├── models/
    │   ├── todo.dart                   # Todo data class (id, title, isCompleted, createdAt)
    │   └── todo_repository.dart        # Storage layer — reads/writes SharedPreferences
    │
    ├── cubit/
    │   ├── todo_cubit.dart             # Business logic — methods like addTodo(), toggleTodo()
    │   └── todo_state.dart             # UI state — TodoState with todos, filter, isLoading
    │
    ├── screens/
    │   └── home_screen.dart            # Main screen — owns BlocProvider, builds full UI
    │
    └── widgets/
        ├── todo_item.dart              # Single todo row — Dismissible swipe-to-delete
        └── add_todo_sheet.dart         # Bottom sheet — text input to create a new todo
```

---

## 🗂️ Where Each File Lives & Why

### `lib/main.dart`
The entry point. Calls `await setupLocator()` before `runApp()` so get_it is ready before any widget builds. No `BlocProvider` here — the Cubit is scoped to the screen, not the whole app.

### `lib/di/service_locator.dart`
All dependency wiring lives here. Think of it as your Hilt `@Module`. Registers `SharedPreferences` and `TodoRepository` as singletons. Any new dependency you add to the app gets registered here.

### `lib/models/todo.dart`
Pure data class. No Flutter imports — just Dart and `equatable`. Contains `copyWith()`, `toJson()`, and `fromJson()`. Keep models free of any framework dependencies.

### `lib/models/todo_repository.dart`
The only class that touches `SharedPreferences`. The Cubit never calls storage directly — it always goes through the repository. This is the same Repository pattern you know from Android.

### `lib/cubit/todo_state.dart`
Defines `TodoState` — the single source of truth for the UI. Also defines the `TodoFilter` enum. Kept in its own file to keep `todo_cubit.dart` focused on logic only.

### `lib/cubit/todo_cubit.dart`
The ViewModel equivalent. Receives `TodoRepository` via constructor injection (supplied by get_it). Exposes plain methods (`addTodo`, `toggleTodo`, etc.) that call `emit()` to update state.

### `lib/screens/home_screen.dart`
The main screen widget. Owns the `BlocProvider` that creates and scopes the `TodoCubit`. Uses `BlocBuilder` to rebuild UI subtrees on state changes. Uses `context.read<TodoCubit>()` inside callbacks to call methods.

### `lib/widgets/todo_item.dart`
A stateless, reusable widget — like a RecyclerView item. Receives `Todo`, `onToggle`, and `onDelete` callbacks. Uses `Dismissible` for swipe-to-delete. Has no direct knowledge of the Cubit.

### `lib/widgets/add_todo_sheet.dart`
A `StatefulWidget` only because it owns a `TextEditingController` (local UI state). Calls `context.read<TodoCubit>().addTodo(text)` on submit. The Cubit is passed in via `BlocProvider.value` from the screen.

---

## 🔄 Data Flow

```
User taps "Add Task"
        │
        ▼
AddTodoSheet (widget)
  context.read<TodoCubit>().addTodo("Buy milk")
        │
        ▼
TodoCubit.addTodo()
  1. Creates new Todo with UUID
  2. emit(state.copyWith(todos: updated))   ← UI updates immediately
  3. await _repository.saveTodos(updated)   ← then persists to disk
        │
        ▼
BlocBuilder<TodoCubit, TodoState> rebuilds
  → ListView shows the new todo
```

---

## 🏗️ Architecture at a Glance

```
┌─────────────────────────────────────────────────┐
│                    UI Layer                      │
│   HomeScreen / TodoItem / AddTodoSheet           │
│   BlocBuilder → reads state                      │
│   context.read → calls cubit methods            │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│                 Cubit Layer                      │
│   TodoCubit — business logic                    │
│   TodoState — immutable UI state                │
│   emit() → pushes new state to BlocBuilder      │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│               Repository Layer                   │
│   TodoRepository — only class touching storage  │
│   SharedPreferences — JSON encoded list         │
└─────────────────────────────────────────────────┘
                     ▲
┌────────────────────┴────────────────────────────┐
│            Dependency Injection (get_it)         │
│   service_locator.dart — wires everything       │
│   getIt<TodoRepository>() — resolves anywhere   │
└─────────────────────────────────────────────────┘
```

---

## 🤝 Android → Flutter Concept Map

| Android | Flutter |
|---|---|
| `ViewModel` | `Cubit` |
| `ViewModelProvider { }` | `BlocProvider(create: ...)` |
| `StateFlow<UiState>` | `Stream<State>` inside Cubit |
| `collectAsState()` | `BlocBuilder<Cubit, State>` |
| `viewModel.doX()` | `context.read<MyCubit>().doX()` |
| `_state.update { copy(...) }` | `emit(state.copyWith(...))` |
| `distinctUntilChanged` | `buildWhen: (prev, curr) => ...` |
| `LaunchedEffect / side effects` | `BlocListener<Cubit, State>` |
| `Hilt @Module` | `service_locator.dart` |
| `@Singleton @Provides` | `getIt.registerSingleton<T>(...)` |
| `@Inject constructor(repo: Repo)` | Constructor arg + `getIt<Repo>()` |
| `SharedPreferences` | `SharedPreferences` (identical API) |
| `data class copy()` | `.copyWith()` |
| `list.filter { }` | `list.where((x) => ...).toList()` |
| `list.map { }` | `list.map((x) => ...).toList()` |
| `BottomSheetDialogFragment` | `showModalBottomSheet(...)` |
| `ItemTouchHelper swipe` | `Dismissible` widget |
| `apply { }` | `..` cascade operator |

---

## ⚙️ Key BlocProvider Rules

```dart
// 1. CREATE — scope Cubit to a screen (not app-wide unless truly global)
BlocProvider(
  create: (_) => TodoCubit(getIt<TodoRepository>()),
  child: MyScreen(),
)

// 2. READ — call a method without subscribing (use in callbacks/onPressed)
context.read<TodoCubit>().addTodo("title");

// 3. WATCH — read state AND subscribe (use inside build() only)
final state = context.watch<TodoCubit>().state;

// 4. BUILDER — rebuild a widget subtree when state changes
BlocBuilder<TodoCubit, TodoState>(
  buildWhen: (prev, curr) => prev.filter != curr.filter, // optional optimization
  builder: (context, state) => Text('${state.activeCount} remaining'),
)

// 5. LISTENER — side effects only (snackbar, navigation) — no rebuild
BlocListener<TodoCubit, TodoState>(
  listenWhen: (prev, curr) => curr.errorMessage != null,
  listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(...),
  child: MyWidget(),
)

// 6. PASS to bottom sheet — don't create a new Cubit, reuse existing
BlocProvider.value(
  value: context.read<TodoCubit>(),
  child: AddTodoSheet(),
)
```

---

## 🚀 Setup & Run

```bash
# 1. Create Flutter project
flutter create todo_bloc_app
cd todo_bloc_app

# 2. Replace pubspec.yaml with the provided one, then:
flutter pub get

# 3. Place files according to the structure above

# 4. Run
flutter run
```

---

## 📦 Dependencies

```yaml
flutter_bloc: ^8.1.6      # BlocProvider, BlocBuilder, Cubit
get_it: ^7.7.0            # Service locator / dependency injection
shared_preferences: ^2.2.3 # Key-value local storage
equatable: ^2.0.5         # Value equality for state comparison
uuid: ^4.4.0              # Unique ID generation for todos
```

---

## 📐 Folder Naming Convention

| Folder | What goes in it |
|---|---|
| `lib/models/` | Data classes + Repository (storage access) |
| `lib/cubit/` | Cubit + State files |
| `lib/screens/` | Full-screen widgets (own their BlocProvider) |
| `lib/widgets/` | Reusable widgets (no BlocProvider, receive callbacks) |
| `lib/di/` | Dependency injection setup (service_locator.dart) |

> As the app grows, add: `lib/services/` for API clients, `lib/utils/` for helpers, `lib/constants/` for app-wide values.