import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:flutter_state_samples/presentation/cubit/screens/tasks/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository _repository;

  TasksCubit(this._repository)
      : super(
          const TasksState(
            tasks: [],
            selected: [],
            isOnEdit: false,
          ),
        );

  void init() {
    _repository.tasks.then((tasks) => emit(state.copyWith(tasks: tasks)));
  }

  void editDone(Task task, bool isDone) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(task);
    final updated = task.copyWith(isDone: isDone);
    await _repository.update(updated);

    tasks.remove(task);
    tasks.insert(index, updated);
    emit(state.copyWith(tasks: tasks));
  }

  void addTask(Task task) async {
    final updated = await _repository.add(task);

    final tasks = List.of(state.tasks);
    tasks.add(updated);
    emit(state.copyWith(tasks: tasks));
  }

  void editTitle(Task task, String title) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(task);
    final updated = task.copyWith(title: title);
    await _repository.update(updated);

    tasks.remove(task);
    tasks.insert(index, updated);
    emit(state.copyWith(tasks: tasks));
  }

  void select(Task task) {
    final selected = List.of(state.selected);
    if (selected.contains(task)) {
      selected.remove(task);
    } else {
      selected.add(task);
    }
    emit(state.copyWith(selected: selected));
  }

  void setOnEdit() => emit(state.copyWith(isOnEdit: true));

  void setOffEdit() => emit(state.copyWith(isOnEdit: false));

  void delete() async {
    final tasks = List.of(state.tasks);
    for (var task in state.selected) {
      await _repository.delete(task);
      tasks.remove(task);
    }
    emit(
      state.copyWith(
        tasks: tasks,
        selected: [],
      ),
    );
  }
}
