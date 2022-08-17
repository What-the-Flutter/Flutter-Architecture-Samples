import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:redux/redux.dart';

import 'tasks_action.dart';
import 'tasks_state.dart';

TasksState reducer(TasksState prevState, dynamic action) {
  return tasksReducer(prevState, action);
}

final Reducer<TasksState> tasksReducer = combineReducers([
  TypedReducer<TasksState, AddTask>(_addItem),
  TypedReducer<TasksState, EditDone>(_editDone),
  TypedReducer<TasksState, EditTitle>(_editTitle),
  TypedReducer<TasksState, SelectTask>(_selectTask),
  TypedReducer<TasksState, TurnOnEditMode>(_setOnEdit),
  TypedReducer<TasksState, TurnOffEditMode>(_setOffEdit),
  TypedReducer<TasksState, ClearSelectedTasks>(_clearSelectedTasks),
  TypedReducer<TasksState, UpdateTasks>(_updateTasks),
]);

TasksState _addItem(TasksState state, AddTask action) {
  final tasks = List<Task>.from(state.tasks)..add(action.task);
  return state.copyWith(tasks: tasks);
}

TasksState _editDone(TasksState state, EditDone action) {
  final tasks = List<Task>.from(state.tasks);
  final index = tasks.indexOf(action.task);
  tasks.remove(action.task);
  final updated = action.task.copyWith(isDone: action.isDone);
  tasks.insert(index, updated);
  return state.copyWith(tasks: tasks);
}

TasksState _editTitle(TasksState state, EditTitle action) {
  final tasks = List<Task>.from(state.tasks);
  final index = tasks.indexOf(action.task);
  tasks.remove(action.task);
  final updated = action.task.copyWith(title: action.title);
  tasks.insert(index, updated);
  return state.copyWith(tasks: tasks);
}

TasksState _selectTask(TasksState state, SelectTask action) {
  final selected = List.of(state.selected);
  if (selected.contains(action.task)) {
    selected.remove(action.task);
  } else {
    selected.add(action.task);
  }
  return state.copyWith(selected: selected);
}

TasksState _setOnEdit(TasksState state, _) => state.copyWith(isOnEdit: true);

TasksState _setOffEdit(TasksState state, _) => state.copyWith(isOnEdit: false);

TasksState _clearSelectedTasks(TasksState state, _) => state.copyWith(selected: const []);

TasksState _updateTasks(TasksState state, UpdateTasks action) => state.copyWith(
      tasks: action.tasks,
      selected: action.selected,
    );
