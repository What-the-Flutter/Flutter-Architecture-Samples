import 'package:flutter/material.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/domain/repositories/task_repository.dart';
import 'package:get/get.dart';

const expandedHeight = 125.0;
const toolbarHeight = 50.0;
const expandDelta = expandedHeight - toolbarHeight;

class TasksController extends GetxController {
  final TaskRepository _repository;

  TasksController(this._repository);

  // Observable fields
  RxBool isOnEdit = false.obs;
  RxList<Task> tasks = <Task>[].obs;
  RxList<Task> selected = <Task>[].obs;

  final ScrollController _scrollController = ScrollController();
  RxDouble expandMultiplier = 1.0.obs;

  ScrollController get scrollController => _scrollController;

  @override
  void onReady() async {
    super.onReady();
    _scrollController.addListener(() {
      final offset = _scrollController.hasClients ? _scrollController.offset : 0;
      expandMultiplier.value = offset > expandDelta ? 0.0 : 1.0 - (offset / expandDelta);
    });

    final fetchedTasks = await _repository.tasks;
    tasks.value = fetchedTasks;
  }

  void editDone(Task task, bool isDone) async {
    final index = tasks.indexOf(task);
    final updated = task.copyWith(isDone: isDone);
    await _repository.update(updated);

    tasks.remove(task);
    tasks.insert(index, updated);
  }

  void addTask(Task task) async {
    final updated = await _repository.add(task);

    tasks.add(updated);
  }

  void editTitle(Task task, String title) async {
    final index = tasks.indexOf(task);
    final updated = task.copyWith(title: title);
    await _repository.update(updated);

    tasks.remove(task);
    tasks.insert(index, updated);
  }

  void select(Task task) {
    if (selected.contains(task)) {
      selected.remove(task);
    } else {
      selected.add(task);
    }
  }

  void setOnEdit() => isOnEdit.value = true;

  void setOffEdit() => isOnEdit.value = false;

  void delete() async {
    for (var task in selected) {
      await _repository.delete(task);
      tasks.remove(task);
    }
    selected.value = [];
  }
}
