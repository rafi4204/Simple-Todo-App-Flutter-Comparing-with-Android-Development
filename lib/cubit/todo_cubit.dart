// lib/cubit/todo_cubit.dart
//
// Cubit = ViewModel with direct methods instead of sealed events.
//
// Android ViewModel:          │  Flutter Cubit:
// ────────────────────────────│──────────────────────────────────────
// fun addTodo(title: String)  │  void addTodo(String title)
//   _state.update { ... }     │    emit(state.copyWith(...))
//                             │
// val uiState: StateFlow      │  // Stream is managed by Cubit internally
//   = _state.asStateFlow()    │  // BlocBuilder subscribes to it
//
// Use Cubit when: simple CRUD, no complex event chains
// Use Bloc when: complex event history, event transformations, analytics

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../models/todo_repository.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState>{
  TodoCubit(super.initialState);

}