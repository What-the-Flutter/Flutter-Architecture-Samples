import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:redux/redux.dart';

import '../../di/injector.dart';
import 'tasks_action.dart';
import 'tasks_state.dart';

final _repository = i.get<TaskRepository>();

final List<Middleware<TasksState>> middleware = [
  TypedMiddleware<TasksState, InitTasks>(_init),
  TypedMiddleware<TasksState, AddTask>(_addTask),
  TypedMiddleware<TasksState, EditDone>(_editDone),
  TypedMiddleware<TasksState, EditTitle>(_editTitle),
  TypedMiddleware<TasksState, DeleteSelectedTasks>(_delete),
];

Future<void> _init(Store<TasksState> store, _, NextDispatcher next) async {
  final tasks = await _repository.tasks;
  next(UpdateTasks(tasks, store.state.selected));
}

Future<void> _addTask(Store<TasksState> store, AddTask action, NextDispatcher next) async {
  final added = await _repository.add(action.task);
  next(AddTask(added));
}

Future<void> _editDone(Store<TasksState> store, EditDone action, NextDispatcher next) async {
  final updated = action.task.copyWith(isDone: action.isDone);
  await _repository.update(updated);
  next(action);
}

Future<void> _editTitle(Store<TasksState> store, EditTitle action, NextDispatcher next) async {
  final updated = action.task.copyWith(title: action.title);
  await _repository.update(updated);
  next(action);
}

Future<void> _delete(
  Store<TasksState> store,
  DeleteSelectedTasks action,
  NextDispatcher next,
) async {
  if (store.state.isOnEdit) {
    next(const TurnOffEditMode());

    final tasks = List.of(store.state.tasks);
    for (var task in store.state.selected) {
      await _repository.delete(task);
      tasks.remove(task);
    }

    next(UpdateTasks(tasks, const []));
  } else {
    next(const TurnOnEditMode());
  }
}
