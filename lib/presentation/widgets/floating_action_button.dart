import 'package:flutter/material.dart';
import 'package:flutter_state_samples/presentation/utils/bottom_sheet.dart';

import '../utils/constants.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final TaskSaveCallback onCreate;

  const CustomFloatingActionButton({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimens.big,
      right: AppDimens.big,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          showSheet(
            context: context,
            onSave: onCreate,
          );
        },
        child: const Icon(Icons.add, size: AppSize.big),
      ),
    );
  }
}
