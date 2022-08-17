import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: AppSize.normal,
      icon: Icon(
        icon,
        color: AppColors.title,
      ),
      onPressed: onTap,
    );
  }
}
