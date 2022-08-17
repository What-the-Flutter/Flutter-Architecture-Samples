import 'package:flutter/material.dart';
import 'package:flutter_state_samples/presentation/cubit/app/app.dart';

import '../../data/data_sources/database_data_source.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseDataSource.initializeHive();
  initInjector();

  runApp(const App());
}
