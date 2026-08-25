import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../app/router/app_router.gr.dart';
import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/cubits/auth_cubit.dart';
import '../../../../auth/models/user.dart';
import 'action_card.dart';

/// Grid of quick-action cards on the dashboard.
class QuickActionsGrid extends StatelessWidget {
  final User? user;
  final void Function(PageRouteInfo route) onNavigate;

  const QuickActionsGrid({
    super.key,
    required this.user,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int crossAxisCount = constraints.maxWidth > 800 ? 6 : 3;

        final actions = [
          if (user?.can(UserPermission.manageStudents) ?? false)
            ActionCard(
              icon: Icons.person_add_rounded,
              label: LocaleKeys.new_student.tr(),
              onTap: () => onNavigate(StudentFormRoute()),
              color: AppColors.actionStudent,
            ),
          if (user?.can(UserPermission.manageGroups) ?? false)
            ActionCard(
              icon: Icons.groups_rounded,
              label: LocaleKeys.groups.tr(),
              onTap: () => onNavigate(const GroupListRoute()),
              color: AppColors.actionGroup,
            ),
          if (user?.can(UserPermission.manageAttendance) ?? false)
            ActionCard(
              icon: Icons.qr_code_scanner_rounded,
              label: LocaleKeys.scan_qr.tr(),
              onTap: () => onNavigate(QrScannerRoute()),
              color: AppColors.actionQrScanner,
            ),
          if (user?.can(UserPermission.managePayments) ?? false)
            ActionCard(
              icon: Icons.payments_rounded,
              label: LocaleKeys.add_payment.tr(),
              onTap: () => onNavigate(PaymentListRoute()),
              color: AppColors.actionPayment,
            ),
          if ((user?.can(UserPermission.generateQrCards) ?? false) ||
              (user?.can(UserPermission.manageStudents) ?? false))
            ActionCard(
              icon: Icons.badge_rounded,
              label: LocaleKeys.qr_card_generator.tr(),
              onTap: () => onNavigate(const QrCardGeneratorRoute()),
              color: AppColors.actionReport,
            ),
          if (user?.can(UserPermission.viewReports) ?? false)
            ActionCard(
              icon: Icons.analytics_rounded,
              label: LocaleKeys.reports.tr(),
              onTap: () => onNavigate(ReportRoute()),
              color: AppColors.actionGroup,
            ),
          if (user?.role == UserRole.admin ||
              (user?.can(UserPermission.manageUsers) ?? false))
            ActionCard(
              icon: Icons.admin_panel_settings_rounded,
              label: LocaleKeys.admin_panel.tr(),
              onTap: () => onNavigate(const AdminPanelRoute()),
              color: AppColors.actionAdmin,
            ),
          if (user?.role == UserRole.admin ||
              (user?.can(UserPermission.manageSettings) ?? true))
            ActionCard(
              icon: Icons.settings_rounded,
              label: LocaleKeys.settings.tr(),
              onTap: () => onNavigate(const SettingsRoute()),
              color: AppColors.actionSettings,
            ),
          ActionCard(
            icon: Icons.logout_rounded,
            label: LocaleKeys.logout.tr(),
            onTap: () => context.read<AuthCubit>().logout(),
            color: colorScheme.error,
          ),
        ];

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimens.p16,
          crossAxisSpacing: AppDimens.p16,
          childAspectRatio: 0.85,
          children: List.generate(
            actions.length,
            (index) => actions[index].animateStaggeredEntrance(index: index),
          ),
        );
      },
    );
  }
}
