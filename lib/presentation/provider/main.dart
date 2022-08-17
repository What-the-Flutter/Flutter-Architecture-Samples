import 'package:flutter/material.dart';

import '../../data/data_sources/database_data_source.dart';
import 'app/app.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseDataSource.initializeHive();
  initInjector();

  runApp(const App());
}
