import 'package:equatable/equatable.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

class TasksState extends Equatable {
  final List<Task> tasks;
  final List<Task> selected;
  final bool isOnEdit;

  const TasksState({
    required this.tasks,
    required this.selected,
    required this.isOnEdit,
  });

  TasksState copyWith({
    List<Task>? tasks,
    List<Task>? selected,
    bool? isOnEdit,
  }) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        selected: selected ?? this.selected,
        isOnEdit: isOnEdit ?? this.isOnEdit,
      );

  @override
  List<Object?> get props => [
        tasks,
        selected,
        isOnEdit,
      ];
}
