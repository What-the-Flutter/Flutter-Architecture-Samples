import 'package:equatable/equatable.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class InitTasks extends TasksEvent {
  const InitTasks();
}

class EditDone extends TasksEvent {
  final Task task;
  final bool isDone;

  const EditDone(this.task, this.isDone);

  @override
  List<Object?> get props => [task, isDone];
}

class AddTask extends TasksEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class EditTitle extends TasksEvent {
  final Task task;
  final String title;

  const EditTitle(this.task, this.title);

  @override
  List<Object?> get props => [task, title];
}

class SelectTask extends TasksEvent {
  final Task task;

  const SelectTask(this.task);

  @override
  List<Object?> get props => [task];
}

class TurnOnEditMode extends TasksEvent {
  const TurnOnEditMode();
}

class TurnOffEditMode extends TasksEvent {
  const TurnOffEditMode();
}

class DeleteSelectedTasks extends TasksEvent {
  const DeleteSelectedTasks();
}
