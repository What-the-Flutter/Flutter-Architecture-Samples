import 'package:flutter/material.dart';
import 'package:flutter_state_samples/data/data_sources/database_data_source.dart';
import 'package:flutter_state_samples/presentation/redux/screens/tasks/tasks_middleware.dart';
import 'package:redux/redux.dart';

import 'screens/tasks/tasks_state.dart';
import 'app/app.dart';
import 'di/injector.dart';
import 'screens/tasks/tasks_reducer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseDataSource.initializeHive();
  initInjector();

  final store = Store<TasksState>(
    reducer,
    initialState: const TasksState.initial(),
    middleware: middleware,
  );
  runApp(App(store: store));
}
