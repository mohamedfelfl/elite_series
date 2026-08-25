import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:student_management_system/generated/locale_keys.g.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';
import 'package:student_management_system/features/payments/cubits/payment_cubit.dart';

class StudentSearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final Function(Map<String, Object?>) onStudentSelected;

  const StudentSearchSection({
    super.key,
    required this.searchController,
    required this.onStudentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 64.r,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.select_student_account.tr(),
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    LocaleKeys.search_payment_desc.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  TextField(
                    controller: searchController,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: LocaleKeys.search_hint.tr(),
                      hintStyle: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    onChanged: (String q) =>
                        context.read<StudentCubit>().search(q),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (BuildContext context, StudentState state) {
              if (state.students.isEmpty && searchController.text.isNotEmpty) {
                return Center(
                  child: Text(
                    LocaleKeys.no_students_found.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: state.students.length,
                separatorBuilder: (BuildContext _, int index) =>
                    SizedBox(height: 8.h),
                itemBuilder: (BuildContext context, int i) {
                  final Map<String, Object?> s = state.students[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              child: Text(
                                (s['name']?.toString() ?? 'S')[0].toUpperCase(),
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              s['name']?.toString() ?? '',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              LocaleKeys.student_serial.tr(
                                args: [s['serial_number'].toString()],
                              ),
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            onTap: () {
                              onStudentSelected(s);
                              context.read<PaymentCubit>().loadPayments(
                                s['id'] as int,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
