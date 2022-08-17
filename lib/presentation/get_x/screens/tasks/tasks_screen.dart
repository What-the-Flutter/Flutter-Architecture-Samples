import 'package:flutter/material.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/presentation/get_x/screens/tasks/tasks_controller.dart';
import 'package:flutter_state_samples/presentation/utils/bottom_sheet.dart';
import 'package:flutter_state_samples/presentation/utils/colors.dart';
import 'package:flutter_state_samples/presentation/utils/constants.dart';
import 'package:flutter_state_samples/presentation/widgets/collapsing_title.dart';
import 'package:flutter_state_samples/presentation/widgets/floating_action_button.dart';
import 'package:flutter_state_samples/presentation/widgets/icon_button.dart';
import 'package:flutter_state_samples/presentation/widgets/task_tile.dart';
import 'package:get/get.dart';

class TasksScreen extends GetView<TasksController> {
  final TasksController _controller = Get.find();

  TasksScreen({Key? key}) : super(key: key);

  void _onDelete() {
    if (_controller.isOnEdit.value) {
      _controller.setOffEdit();
      _controller.delete();
    } else {
      _controller.setOnEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final done = _controller.tasks.where((task) => task.isDone).map(_taskToTile).toList();
        final todo = _controller.tasks.where((task) => !task.isDone).map(_taskToTile).toList();
        return Material(
          child: Stack(
            children: [
              ColoredBox(
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.normal),
                  child: CustomScrollView(
                    controller: _controller.scrollController,
                    slivers: [
                      _appBar(context, todo),
                      _taskList(todo, done),
                    ],
                  ),
                ),
              ),
              CustomFloatingActionButton(
                onCreate: (title) => _controller.addTask(Task(isDone: false, title: title)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appBar(BuildContext context, List<TaskTile> todo) {
    return SliverAppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      expandedHeight: expandedHeight,
      toolbarHeight: toolbarHeight,
      pinned: true,
      leadingWidth: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        title: CollapsingTitle(
          expandMultiplier: _controller.expandMultiplier.value,
          count: todo.length,
        ),
      ),
      actions: [
        if (_controller.isOnEdit.value)
          CustomIconButton(
            icon: Icons.close,
            onTap: _controller.setOffEdit,
          ),
        CustomIconButton(
          icon: Icons.delete,
          onTap: () => _onDelete(),
        ),
      ],
    );
  }

  Widget _taskList(List<TaskTile> todo, List<TaskTile> done) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ...todo,
          const SizedBox(height: AppDimens.normal),
          if (done.isNotEmpty) ...[
            Text(
              'done (${done.length})',
              style: const TextStyle(color: AppColors.subtitle),
            ),
            ...done,
          ],
        ],
      ),
    );
  }

  TaskTile _taskToTile(Task task) {
    return TaskTile(
      task: task,
      onDone: (isDone) => _controller.editDone(task, isDone),
      isSelected: _controller.selected.contains(task),
      onSelect: (isSelected) => _controller.select(task),
      isOnEdit: _controller.isOnEdit.value,
      onLongPress: () {
        _controller.setOnEdit();
        _controller.select(task);
      },
      onTap: () async => await Get.bottomSheet(
        NewTaskBottomSheet(
          task: task,
          onSave: (title) => _controller.editTitle(task, title),
        ),
      ),
    );
  }
}
