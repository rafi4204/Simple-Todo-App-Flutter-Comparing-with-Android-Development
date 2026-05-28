// lib/cubit/todo_state.dart
//
// With Cubit there are NO events — just states.
// The Cubit exposes methods directly (like ViewModel functions).
// State is one class with copyWith — cleaner than sealed events for simple CRUD.

import 'package:equatable/equatable.dart';
import '../models/todo.dart';

enum TodoFilter { all, active, completed }

// ONE state class — holds everything the UI needs
// Like a single UiState data class in Android ViewModel
class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;
  final bool isLoading;
  final String? errorMessage;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.isLoading = false,
    this.errorMessage,
  });

  // Filtered list — computed from current state
  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.all:
        return todos;
      case TodoFilter.completed:
        return todos.where((t) => t.isCompleted).toList();
    }
  }

  int get activeCount =>
      todos
          .where((t) => !t.isCompleted)
          .length;

  int get completedCount =>
      todos
          .where((t) => t.isCompleted)
          .length;

  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
    bool? isLoading,
    String? errorMessage
  }) {
    return TodoState(
        todos: todos ?? this.todos,
        filter: filter ?? this.filter,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage
    );
  }

  @override
  List<Object?> get props => [todos, filter, isLoading, errorMessage];
}
