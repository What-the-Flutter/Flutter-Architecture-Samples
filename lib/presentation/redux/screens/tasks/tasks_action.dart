import 'package:equatable/equatable.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

abstract class TasksAction extends Equatable {
  const TasksAction();

  @override
  List<Object?> get props => [];
}

class InitTasks extends TasksAction {
  const InitTasks();
}

class UpdateTasks extends TasksAction {
  final List<Task> tasks;
  final List<Task> selected;

  const UpdateTasks(this.tasks, this.selected);

  @override
  List<Object?> get props => [tasks, selected];
}

class EditDone extends TasksAction {
  final Task task;
  final bool isDone;

  const EditDone(this.task, this.isDone);

  @override
  List<Object?> get props => [task, isDone];
}

class AddTask extends TasksAction {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class EditTitle extends TasksAction {
  final Task task;
  final String title;

  const EditTitle(this.task, this.title);

  @override
  List<Object?> get props => [task, title];
}

class SelectTask extends TasksAction {
  final Task task;

  const SelectTask(this.task);

  @override
  List<Object?> get props => [task];
}

class TurnOnEditMode extends TasksAction {
  const TurnOnEditMode();
}

class TurnOffEditMode extends TasksAction {
  const TurnOffEditMode();
}

class ClearSelectedTasks extends TasksAction {
  const ClearSelectedTasks();
}

class DeleteSelectedTasks extends TasksAction {
  const DeleteSelectedTasks();
}
