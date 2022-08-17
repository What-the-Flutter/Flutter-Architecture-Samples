import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../screens/tasks/tasks_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
      ),
      home: const TasksScreen(),
    );
  }
}
