import 'package:flutter/foundation.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';

import '../../di/injector.dart';

class TasksModel extends ChangeNotifier {
  final _repository = i.get<TaskRepository>();

  final List<Task> _tasks;
  final List<Task> _selected;
  bool _isOnEdit;

  TasksModel(
    this._tasks,
    this._selected,
    this._isOnEdit,
  );

  TasksModel.initial()
      : _tasks = [],
        _selected = [],
        _isOnEdit = false;

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get selected => List.unmodifiable(_selected);

  bool get isOnEdit => _isOnEdit;

  void init() async {
    final tasks = await _repository.tasks;
    _tasks.addAll(tasks);
    notifyListeners();
  }

  void editDone(Task task, bool isDone) async {
    final index = _tasks.indexOf(task);
    final updated = task.copyWith(isDone: isDone);
    await _repository.update(updated);

    _tasks.remove(task);
    _tasks.insert(index, updated);
    notifyListeners();
  }

  void addTask(Task task) async {
    final updated = await _repository.add(task);
    _tasks.add(updated);
    notifyListeners();
  }

  void editTitle(Task task, String title) async {
    final index = _tasks.indexOf(task);
    final updated = task.copyWith(title: title);
    await _repository.update(updated);

    _tasks.remove(task);
    _tasks.insert(index, updated);
    notifyListeners();
  }

  void select(Task task) {
    if (_selected.contains(task)) {
      _selected.remove(task);
    } else {
      _selected.add(task);
    }
    notifyListeners();
  }

  void setOnEdit() {
    _isOnEdit = true;
    notifyListeners();
  }

  void setOffEdit() {
    _isOnEdit = false;
    notifyListeners();
  }

  void delete() async {
    for (var task in _selected) {
      await _repository.delete(task);
      _tasks.remove(task);
    }
    _selected.clear();
    notifyListeners();
  }
}
