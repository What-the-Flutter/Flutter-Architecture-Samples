import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../screens/tasks/tasks_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp is necessary for routes, snackbars, internationalization, bottomSheets,
    // dialogs, and high-level apis related to routes and absence of context
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
      ),
      home: const TasksScreen(),
    );
  }
}
