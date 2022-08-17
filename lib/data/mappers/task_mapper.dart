import 'package:flutter_state_samples/data/entities/task_db.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

extension TaskMapper on TaskDB {
  Task fromHive() {
    return Task(id: id, title: title, isDone: isDone);
  }
}

extension TaskDbMapper on Task {
  TaskDB toHive() {
    return TaskDB(id: id, title: title, isDone: isDone);
  }
}

