import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class QuestionOptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool revealed;
  final bool isCorrectOption;
  final VoidCallback? onTap;

  const QuestionOptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.revealed,
    required this.isCorrectOption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? borderColor;
    Color? fillColor;
    IconData? trailingIcon;

    if (revealed) {
      if (isCorrectOption) {
        borderColor = AppColors.success;
        fillColor = AppColors.success.withValues(alpha: 0.12);
        trailingIcon = Icons.check_circle;
      } else if (isSelected) {
        borderColor = AppColors.error;
        fillColor = AppColors.error.withValues(alpha: 0.12);
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      borderColor = AppColors.bordeaux;
      fillColor = AppColors.bordeaux.withValues(alpha: 0.08);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: fillColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor ?? Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(child: Text(text)),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: borderColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
