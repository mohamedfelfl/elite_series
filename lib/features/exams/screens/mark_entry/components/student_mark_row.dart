import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../generated/locale_keys.g.dart';

/// A single student row in the mark entry table with score input and color coding.
class StudentMarkRow extends StatelessWidget {
  final Map<String, Object?> student;
  final TextEditingController scoreController;
  final GlobalKey studentKey;
  final bool isHighlighted;
  final double? fullMark;

  const StudentMarkRow({
    super.key,
    required this.student,
    required this.scoreController,
    required this.studentKey,
    required this.isHighlighted,
    this.fullMark,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      key: studentKey,
      color: isHighlighted
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                student['serial_number']?.toString() ?? '',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Text(
                student['name']?.toString() ?? '',
                style: textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              width: 100,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: scoreController,
                builder: (context, value, child) {
                  Color? fillColor;
                  if (fullMark != null) {
                    final markText = value.text;
                    if (markText.isNotEmpty) {
                      final mark = double.tryParse(markText);
                      if (mark != null) {
                        final ratio = (mark / fullMark!).clamp(0.0, 1.0);
                        if (ratio > 0.5) {
                          fillColor = Color.lerp(
                            Colors.yellow,
                            Colors.green,
                            (ratio - 0.5) * 2,
                          )?.withValues(alpha: 0.3);
                        } else if (ratio < 0.5) {
                          fillColor = Color.lerp(
                            Colors.red,
                            Colors.yellow,
                            ratio * 2,
                          )?.withValues(alpha: 0.3);
                        } else {
                          fillColor = Colors.yellow.withValues(alpha: 0.3);
                        }
                      }
                    }
                  }

                  return TextField(
                    controller: scoreController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: LocaleKeys.score.tr(),
                      isDense: true,
                      filled: fillColor != null,
                      fillColor: fillColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (val) {
                      if (fullMark != null) {
                        final mark = double.tryParse(val);
                        if (mark != null && mark > fullMark!) {
                          scoreController.text = fullMark.toString();
                          scoreController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: scoreController.text.length,
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
