import 'package:flutter/material.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../app/shared/animations/pressable_scale.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PressableScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.r24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimens.r24),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.15 : 0.08),
            width: 1.2,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                blurRadius: AppDimens.r12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimens.p12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppDimens.iconSize28, color: color),
            ),
            SizedBox(height: AppDimens.h12),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
