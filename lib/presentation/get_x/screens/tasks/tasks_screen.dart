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

// GetView is a const Stateless Widget that has a getter `controller` for a registered Controller
class TasksScreen extends GetView<TasksController> {
  const TasksScreen({Key? key}) : super(key: key);

  void _onDelete() {
    if (controller.isOnEdit.value) {
      controller.setOffEdit();
      controller.delete();
    } else {
      controller.setOnEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obx updates the widgets whenever the _controller obs fields change
    return Obx(
      () {
        final done = controller.tasks.where((task) => task.isDone).map(_taskToTile).toList();
        final todo = controller.tasks.where((task) => !task.isDone).map(_taskToTile).toList();
        return Material(
          child: Stack(
            children: [
              ColoredBox(
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.normal),
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      _appBar(context, todo),
                      _taskList(todo, done),
                    ],
                  ),
                ),
              ),
              CustomFloatingActionButton(
                onCreate: (title) => controller.addTask(Task(isDone: false, title: title)),
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
          expandMultiplier: controller.expandMultiplier.value,
          count: todo.length,
        ),
      ),
      actions: [
        if (controller.isOnEdit.value)
          CustomIconButton(
            icon: Icons.close,
            onTap: controller.setOffEdit,
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
      onDone: (isDone) => controller.editDone(task, isDone),
      isSelected: controller.selected.contains(task),
      onSelect: (isSelected) => controller.select(task),
      isOnEdit: controller.isOnEdit.value,
      onLongPress: () {
        controller.setOnEdit();
        controller.select(task);
      },
      onTap: () async => await Get.bottomSheet(
        NewTaskBottomSheet(
          task: task,
          onSave: (title) => controller.editTitle(task, title),
        ),
      ),
    );
  }
}
