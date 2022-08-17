import 'package:flutter/material.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/presentation/utils/bottom_sheet.dart';
import 'package:flutter_state_samples/presentation/utils/colors.dart';
import 'package:flutter_state_samples/presentation/utils/constants.dart';
import 'package:flutter_state_samples/presentation/widgets/collapsing_title.dart';
import 'package:flutter_state_samples/presentation/widgets/floating_action_button.dart';
import 'package:flutter_state_samples/presentation/widgets/icon_button.dart';
import 'package:flutter_state_samples/presentation/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import 'tasks_model.dart';

const _expandedHeight = 125.0;
const _toolbarHeight = 50.0;
const _expandDelta = _expandedHeight - _toolbarHeight;

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ScrollController _scrollController = ScrollController();
  double _expandMultiplier = 1.0;

  void _onDelete(TasksModel model) {
    if (model.isOnEdit) {
      model.setOffEdit();
      model.delete();
    } else {
      model.setOnEdit();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      final offset = _scrollController.hasClients ? _scrollController.offset : 0;
      setState(() {
        _expandMultiplier = offset > _expandDelta ? 0.0 : 1.0 - (offset / _expandDelta);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksModel>(
      builder: (context, model, _) {
        final done = model.tasks
            .where((task) => task.isDone)
            .map((task) => _taskToTile(model, task))
            .toList();
        final todo = model.tasks
            .where((task) => !task.isDone)
            .map((task) => _taskToTile(model, task))
            .toList();
        return Material(
          child: Stack(
            children: [
              ColoredBox(
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.normal),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      _appBar(model, todo),
                      _taskList(todo, done),
                    ],
                  ),
                ),
              ),
              CustomFloatingActionButton(
                onCreate: (title) => model.addTask(Task(isDone: false, title: title)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appBar(TasksModel model, List<TaskTile> todo) {
    return SliverAppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      expandedHeight: _expandedHeight,
      toolbarHeight: _toolbarHeight,
      pinned: true,
      leadingWidth: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        title: CollapsingTitle(
          expandMultiplier: _expandMultiplier,
          count: todo.length,
        ),
      ),
      actions: [
        if (model.isOnEdit)
          CustomIconButton(
            icon: Icons.close,
            onTap: model.setOffEdit,
          ),
        CustomIconButton(
          icon: Icons.delete,
          onTap: () => _onDelete(model),
        ),
      ],
    );
  }

  Widget _taskList(List<TaskTile> todo, List<TaskTile> done) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ...todo,
        const SizedBox(height: AppDimens.normal),
        if (done.isNotEmpty) ...[
          Text(
            'done (${done.length})',
            style: const TextStyle(color: AppColors.subtitle),
          ),
          ...done,
        ],
      ]),
    );
  }

  TaskTile _taskToTile(TasksModel model, Task task) {
    return TaskTile(
      task: task,
      onDone: (isDone) => model.editDone(task, isDone),
      isSelected: model.selected.contains(task),
      onSelect: (isSelected) => model.select(task),
      isOnEdit: model.isOnEdit,
      onLongPress: () {
        model.setOnEdit();
        model.select(task);
      },
      onTap: () {
        showSheet(
          context: context,
          task: task,
          onSave: (title) => model.editTitle(task, title),
        );
      },
    );
  }
}
