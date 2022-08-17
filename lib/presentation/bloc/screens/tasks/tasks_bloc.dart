import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:flutter_state_samples/presentation/bloc/screens/tasks/tasks_event.dart';
import 'package:flutter_state_samples/presentation/cubit/screens/tasks/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository _repository;

  TasksBloc(this._repository)
      : super(
          const TasksState(
            tasks: [],
            selected: [],
            isOnEdit: false,
          ),
        ) {
    on<InitTasks>(_init);
    on<EditDone>(_editDone);
    on<AddTask>(_addTask);
    on<EditTitle>(_editTitle);
    on<SelectTask>(_select);
    on<TurnOnEditMode>(_setOnEdit);
    on<TurnOffEditMode>(_setOffEdit);
    on<DeleteSelectedTasks>(_delete);
  }

  void _init(_, Emitter<TasksState> emit) async {
    final tasks = await _repository.tasks;
    emit(state.copyWith(tasks: tasks));
  }

  void _editDone(EditDone event, Emitter<TasksState> emit) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(event.task);
    final updated = event.task.copyWith(isDone: event.isDone);
    await _repository.update(updated);

    tasks.remove(event.task);
    tasks.insert(index, updated);
    emit(state.copyWith(tasks: tasks));
  }

  void _addTask(AddTask event, Emitter<TasksState> emit) async {
    final updated = await _repository.add(event.task);

    final tasks = List.of(state.tasks);
    tasks.add(updated);
    emit(state.copyWith(tasks: tasks));
  }

  void _editTitle(EditTitle event, Emitter<TasksState> emit) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(event.task);
    final updated = event.task.copyWith(title: event.title);
    await _repository.update(updated);

    tasks.remove(event.task);
    tasks.insert(index, updated);
    emit(state.copyWith(tasks: tasks));
  }

  void _select(SelectTask event, Emitter<TasksState> emit) {
    final selected = List.of(state.selected);
    if (selected.contains(event.task)) {
      selected.remove(event.task);
    } else {
      selected.add(event.task);
    }
    emit(state.copyWith(selected: selected));
  }

  void _setOnEdit(_, Emitter<TasksState> emit) => emit(state.copyWith(isOnEdit: true));

  void _setOffEdit(_, Emitter<TasksState> emit) => emit(state.copyWith(isOnEdit: false));

  void _delete(_, Emitter<TasksState> emit) async {
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
