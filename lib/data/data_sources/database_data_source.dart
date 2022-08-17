import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_state_samples/data/mappers/task_mapper.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../entities/task_db.dart';

class DatabaseDataSource {
  static const _tasksTag = 'tasks';
  static const _testTag = 'test';
  static late final Box<TaskDB> _tasksBox;

  static Future<void> initializeHive({isTesting = false}) async {
    if (!kIsWeb) {
      try {
        Directory document = await getApplicationDocumentsDirectory();
        Hive.init(document.path);
      } catch (e) {
        Hive.init('/Users/hahanya/test-todo/test/');
      }
    }
    Hive.registerAdapter(TaskDBAdapter());
    _tasksBox = await Hive.openBox<TaskDB>(isTesting ? _testTag : _tasksTag);
    if (isTesting) await _tasksBox.clear();
  }

  DatabaseDataSource();

  Future<void> dispose() async {
    await _tasksBox.close();
  }

  Future<Task> createTask(Task task) async {
    final toCreate = TaskDB(title: task.title, isDone: task.isDone);
    final id = await _tasksBox.add(toCreate);
    final created = toCreate.copyWith(id: id);
    await _tasksBox.put(id, created);
    return created.fromHive();
  }

  Future<List<Task>> getTasks() async {
    Iterable<TaskDB> result;
    result = _tasksBox.values;
    return List<Task>.generate(result.length, (index) => result.elementAt(index).fromHive());
  }

  Future<void> deleteTask(int taskId) async {
    return _tasksBox.delete(taskId);
  }

  Future<void> updateTask(Task task) async => _tasksBox.put(task.id!, task.toHive());
}
