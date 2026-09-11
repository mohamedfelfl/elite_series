import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';

import '../../../../../app/utils/arabic_name_helper.dart';
import 'student_duplicate_warning_card.dart';

/// Personal Information & Educational History sections for Student Form.
/// Split into two clearly organized cards:
/// 1. Personal & Contact Details (Name, Phones, Address, Father's job)
/// 2. Educational Background & Notes (School, Previous teacher, Student notes)
class StudentInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phone1Controller;
  final TextEditingController phone2Controller;
  final TextEditingController fatherJobController;
  final TextEditingController schoolController;
  final TextEditingController previousTeacherController;
  final TextEditingController? notesController;
  final String? Function(String?)? nameValidator;
  final List<NameDuplicateMatch> duplicateMatches;

  const StudentInfoSection({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.phone1Controller,
    required this.phone2Controller,
    required this.fatherJobController,
    required this.schoolController,
    required this.previousTeacherController,
    this.notesController,
    this.nameValidator,
    this.duplicateMatches = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ═══════════════════════════════════════════════════════════════════════
        // CARD 1: PERSONAL & CONTACT INFORMATION
        // ═══════════════════════════════════════════════════════════════════════
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.personal_info_section.tr(),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          LocaleKeys.student_name.tr(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: nameController,
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  labelText: '${LocaleKeys.name.tr()} *',
                  hintText: 'أدخل الاسم الثلاثي أو الرباعي للطالب',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                  ),
                ),
                validator: nameValidator ??
                    (v) => (v == null || v.trim().isEmpty)
                        ? LocaleKeys.required_field.tr()
                        : null,
              ),

              if (duplicateMatches.isNotEmpty)
                StudentDuplicateWarningCard(matches: duplicateMatches),

              const SizedBox(height: 18),

              // Phone 1 & Phone 2 (Side by side)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 480;
                  final phone1Field = TextFormField(
                    controller: phone1Controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: InputDecoration(
                      labelText: LocaleKeys.phone1.tr(),
                      prefixIcon: const Icon(Icons.phone_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  final phone2Field = TextFormField(
                    controller: phone2Controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: InputDecoration(
                      labelText: LocaleKeys.phone2.tr(),
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  if (!isWide) {
                    return Column(
                      children: [
                        phone1Field,
                        const SizedBox(height: 18),
                        phone2Field,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: phone1Field),
                      const SizedBox(width: 14),
                      Expanded(child: phone2Field),
                    ],
                  );
                },
              ),

              const SizedBox(height: 18),

              // Father's Job & Address (Side by side on wide screens)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 480;
                  final fatherJobField = TextFormField(
                    controller: fatherJobController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.father_job.tr(),
                      prefixIcon: const Icon(Icons.work_outline_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  final addressField = TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.address.tr(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  if (!isWide) {
                    return Column(
                      children: [
                        fatherJobField,
                        const SizedBox(height: 18),
                        addressField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: fatherJobField),
                      const SizedBox(width: 14),
                      Expanded(child: addressField),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ═══════════════════════════════════════════════════════════════════════
        // CARD 2: EDUCATIONAL BACKGROUND & NOTES
        // ═══════════════════════════════════════════════════════════════════════
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.history_edu_rounded,
                      color: colorScheme.onSecondaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.educational_info_section.tr(),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          LocaleKeys.school.tr(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // School & Previous Teacher (Side by side on wide screens)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 480;
                  final schoolField = TextFormField(
                    controller: schoolController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.school.tr(),
                      prefixIcon: const Icon(Icons.apartment_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  final previousTeacherField = TextFormField(
                    controller: previousTeacherController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.previous_teacher.tr(),
                      prefixIcon: const Icon(Icons.person_search_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      ),
                    ),
                  );

                  if (!isWide) {
                    return Column(
                      children: [
                        schoolField,
                        const SizedBox(height: 18),
                        previousTeacherField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: schoolField),
                      const SizedBox(width: 14),
                      Expanded(child: previousTeacherField),
                    ],
                  );
                },
              ),

              if (notesController != null) ...[
                const SizedBox(height: 18),
                TextFormField(
                  controller: notesController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.student_notes.tr(),
                    hintText: LocaleKeys.student_notes_hint.tr(),
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
