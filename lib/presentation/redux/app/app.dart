import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_state_samples/presentation/redux/screens/tasks/tasks_state.dart';
import 'package:redux/redux.dart';

import '../../utils/colors.dart';
import '../screens/tasks/tasks_screen.dart';

class App extends StatelessWidget {
  final Store<TasksState> store;

  const App({required this.store, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
        ),
        home: const TasksScreen(),
      ),
    );
  }
}
