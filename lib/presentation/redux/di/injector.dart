import 'package:flutter_state_samples/data/data_sources/database_data_source.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:get_it/get_it.dart';

GetIt get i => GetIt.instance;

void initInjector() {
  _initDataSources();
  _initRepositories();
}

void _initDataSources() {
  i.registerSingleton<DatabaseDataSource>(DatabaseDataSource());
}

void _initRepositories() {
  i.registerSingleton<TaskRepository>(TaskRepository(i.get()));
}

