// lib/models/todo_repository.dart
//
// Repository — same pattern as Android.
// get_it will inject this into the Cubit automatically.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo.dart';

class TodoRepository {
  static const _key = 'todos';
  final SharedPreferences _prefs;

  // Constructor injection — get_it will pass SharedPreferences in
  // Like @Inject constructor(prefs: SharedPreferences) in Hilt
  TodoRepository(this._prefs);

  List<Todo> loadTodos() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final encoded = jsonEncode(todos.map((t) => t.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
