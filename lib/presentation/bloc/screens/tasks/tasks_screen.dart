import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';
import 'package:flutter_state_samples/presentation/utils/bottom_sheet.dart';
import 'package:flutter_state_samples/presentation/utils/colors.dart';
import 'package:flutter_state_samples/presentation/utils/constants.dart';
import 'package:flutter_state_samples/presentation/widgets/collapsing_title.dart';
import 'package:flutter_state_samples/presentation/widgets/floating_action_button.dart';
import 'package:flutter_state_samples/presentation/widgets/icon_button.dart';
import 'package:flutter_state_samples/presentation/widgets/task_tile.dart';

import '../../di/injector.dart';
import 'tasks_bloc.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

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

  late final TasksBloc _bloc;

  void _onDelete(TasksState state) {
    if (state.isOnEdit) {
      _bloc.add(const TurnOffEditMode());
      _bloc.add(const DeleteSelectedTasks());
    } else {
      _bloc.add(const TurnOnEditMode());
    }
  }

  @override
  void initState() {
    _bloc = i.get<TasksBloc>()..add(const InitTasks());
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
    return BlocBuilder<TasksBloc, TasksState>(
      bloc: _bloc,
      builder: (context, state) {
        final done = state.tasks.where((task) => task.isDone).map(_taskToTile).toList();
        final todo = state.tasks.where((task) => !task.isDone).map(_taskToTile).toList();
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
                      _appBar(state, todo),
                      _taskList(todo, done),
                    ],
                  ),
                ),
              ),
              CustomFloatingActionButton(
                onCreate: (title) => _bloc.add(AddTask(Task(isDone: false, title: title))),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appBar(TasksState state, List<TaskTile> todo) {
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
        if (state.isOnEdit)
          CustomIconButton(
            icon: Icons.close,
            onTap: () => _bloc.add(const TurnOffEditMode()),
          ),
        CustomIconButton(
          icon: Icons.delete,
          onTap: () => _onDelete(state),
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

  TaskTile _taskToTile(Task task) {
    return TaskTile(
      task: task,
      onDone: (isDone) => _bloc.add(EditDone(task, isDone)),
      isSelected: _bloc.state.selected.contains(task),
      onSelect: (isSelected) => _bloc.add(SelectTask(task)),
      isOnEdit: _bloc.state.isOnEdit,
      onLongPress: () {
        _bloc.add(const TurnOnEditMode());
        _bloc.add(SelectTask(task));
      },
      onTap: () {
        showSheet(
          context: context,
          task: task,
          onSave: (title) => _bloc.add(EditTitle(task, title)),
        );
      },
    );
  }
}
