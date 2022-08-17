import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:redux/redux.dart';

import 'tasks_action.dart';
import 'tasks_state.dart';

class TasksViewModel extends Equatable {
  final List<Task> tasks;
  final List<Task> selected;
  final bool isOnEdit;

  final VoidCallback init;
  final Function(Task) addTask;
  final Function(Task, bool) editDone;
  final Function(Task, String) editTitle;
  final Function(Task) selectTask;
  final Function(Task) longPressTask;
  final VoidCallback deleteSelectedTasks;
  final VoidCallback turnOnEditMode;
  final VoidCallback turnOffEditMode;

  const TasksViewModel({
    required this.tasks,
    required this.selected,
    required this.isOnEdit,
    required this.init,
    required this.addTask,
    required this.editDone,
    required this.editTitle,
    required this.selectTask,
    required this.longPressTask,
    required this.deleteSelectedTasks,
    required this.turnOnEditMode,
    required this.turnOffEditMode,
  });

  static TasksViewModel from(Store<TasksState> store) {
    return TasksViewModel(
      tasks: store.state.tasks,
      selected: store.state.selected,
      isOnEdit: store.state.isOnEdit,
      init: () => store.dispatch(const InitTasks()),
      addTask: (task) => store.dispatch(AddTask(task)),
      editDone: (task, isDone) => store.dispatch(EditDone(task, isDone)),
      editTitle: (task, title) => store.dispatch(EditTitle(task, title)),
      selectTask: (task) => store.dispatch(SelectTask(task)),
      longPressTask: (task) {
        if (!store.state.isOnEdit) {
          store.dispatch(const TurnOnEditMode());
        }
        store.dispatch(SelectTask(task));
      },
      deleteSelectedTasks: () => store.dispatch(const DeleteSelectedTasks()),
      turnOnEditMode: () => store.dispatch(const TurnOnEditMode()),
      turnOffEditMode: () {
        store.dispatch(const TurnOffEditMode());
        store.dispatch(const ClearSelectedTasks());
      },
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        selected,
        isOnEdit,
      ];
}
