import 'package:flutter_state_samples/data/data_sources/database_data_source.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:get/get.dart';

import '../screens/tasks/tasks_controller.dart';

void initInjector() {
  _initDataSources();
  _initRepositories();
  _initControllers();
}

void _initDataSources() {
  Get.put(DatabaseDataSource(), permanent: true);
}

void _initRepositories() {
  Get.put(TaskRepository(Get.find()), permanent: true);
}

void _initControllers() {
  Get.put(TasksController(Get.find()));
}
