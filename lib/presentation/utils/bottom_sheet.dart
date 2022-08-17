import 'package:flutter/material.dart';
import 'package:flutter_state_samples/domain/entities/task.dart';

import 'colors.dart';
import 'constants.dart';

typedef TaskSaveCallback = void Function(String);

void showSheet({
  required BuildContext context,
  required TaskSaveCallback onSave,
  Task? task,
}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (context) => NewTaskBottomSheet(onSave: onSave, task: task),
  );
}

class NewTaskBottomSheet extends StatelessWidget {
  final TaskSaveCallback onSave;
  final Task? task;

  const NewTaskBottomSheet({
    required this.onSave,
    this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: task?.title ?? '');
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.normal),
            topRight: Radius.circular(AppRadius.normal),
          ),
        ),
        padding: const EdgeInsets.all(AppDimens.normal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.tiny),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.outline, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(AppRadius.normal)),
              ),
              child: TextField(
                maxLines: 5,
                minLines: 1,
                autofocus: true,
                cursorColor: AppColors.accent,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'New to-do',
                ),
                controller: _controller,
              ),
            ),
            const SizedBox(height: AppDimens.small),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: AppColors.accent,
                ),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    onSave(_controller.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
