import 'package:flutter_state_samples/data/data_sources/database_data_source.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:flutter_state_samples/presentation/get_x/screens/tasks/tasks_controller.dart';
import 'package:get/get.dart';

void initInjector() {
  _initDataSources();
  _initRepositories();
  _initCubits();
}

void _initDataSources() {
  Get.put(DatabaseDataSource());
}

void _initRepositories() {
  Get.put(TaskRepository(Get.find()));
}

void _initCubits() {
  Get.put(TasksController(Get.find()));
}
