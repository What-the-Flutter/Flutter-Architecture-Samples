import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CollapsingTitle extends StatelessWidget {
  final double expandMultiplier;
  final int count;

  const CollapsingTitle({
    Key? key,
    required this.expandMultiplier,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To-dos",
                style: TextStyle(
                  fontSize: 22 + (20 * expandMultiplier),
                  color: AppColors.title,
                ),
              ),
              Text(
                "$count to-dos",
                style: TextStyle(
                  fontSize: 16 * expandMultiplier,
                  color: AppColors.accent.withOpacity(expandMultiplier),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 1,
            width: MediaQuery.of(context).size.width * (1 - expandMultiplier),
            child: const Divider(height: 1),
          ),
        ),
      ],
    );
  }
}
