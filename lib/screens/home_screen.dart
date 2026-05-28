// lib/screens/home_screen.dart
//
// BlocProvider scopes the Cubit to this screen's subtree.
// BlocBuilder subscribes to state changes — like collectAsState() in Compose.
//
// RULE:
//   context.read<TodoCubit>()          → call methods (no rebuild subscription)
//   context.watch<TodoCubit>().state   → read state AND subscribe (inside build only)
//   BlocBuilder                        → rebuild a subtree when state changes

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../di/service_locator.dart';
import '../models/todo_repository.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_sheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) => TodoCubit(),
    );

  }


}