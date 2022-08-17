import 'package:flutter/material.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

typedef SwitchCallback = void Function(bool);

class TaskTile extends StatefulWidget {
  final Task task;
  final SwitchCallback onDone;
  final SwitchCallback onSelect;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool isOnEdit;
  final bool isSelected;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onDone,
    required this.onSelect,
    required this.onLongPress,
    required this.onTap,
    required this.isOnEdit,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: AppDuration.normal,
    vsync: this,
  );
  late final Animation<double> _animation = Tween<double>(
    begin: 1.0,
    end: 0.95,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _opacity = widget.task.isDone ? 0.5 : 1.0;
    return GestureDetector(
      onPanDown: (_) {
        _controller.forward();
      },
      onPanEnd: (_) {
        _controller.reverse();
      },
      onPanCancel: () {
        _controller.reverse();
      },
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _animation,
        child: AnimatedContainer(
          margin: const EdgeInsets.all(AppDimens.tiny),
          padding: const EdgeInsets.all(AppDimens.small),
          decoration: BoxDecoration(
            color: widget.task.isDone ? AppColors.doneBackground : AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.normal)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isOnEdit) ...[
                _Leading(
                  onTap: () => widget.onDone(!widget.task.isDone),
                  isDone: widget.task.isDone,
                  opacity: _opacity,
                ),
                const SizedBox(width: AppDimens.small),
              ],
              _Title(title: widget.task.title, opacity: _opacity),
              if (widget.isOnEdit) ...[
                const SizedBox(width: AppDimens.small),
                _Trailing(
                  isSelected: widget.isSelected,
                  onTap: () => widget.onSelect(!widget.isSelected),
                  opacity: _opacity,
                ),
              ],
            ],
          ),
          duration: AppDuration.normal,
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  final VoidCallback onTap;
  final double opacity;
  final bool isDone;

  const _Leading({
    Key? key,
    required this.onTap,
    required this.opacity,
    required this.isDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppDimens.tiny),
        height: AppSize.normal,
        width: AppSize.normal,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outline.withOpacity(opacity), width: 1),
        ),
        child: Icon(
          Icons.done,
          size: AppSize.small,
          color: isDone ? AppColors.outline.withOpacity(opacity) : AppColors.transparent,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final double opacity;

  const _Title({Key? key, required this.title, required this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: AppDimens.tiny),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.title.withOpacity(opacity),
          ),
        ),
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  final VoidCallback onTap;
  final double opacity;
  final bool isSelected;

  const _Trailing({
    Key? key,
    required this.opacity,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppDimens.tiny),
        height: AppSize.normal,
        width: AppSize.normal,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.transparent,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: AppColors.outline.withOpacity(opacity),
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Icon(
          Icons.done,
          size: AppSize.small,
          color: isSelected ? AppColors.white : AppColors.transparent,
        ),
      ),
    );
  }
}
