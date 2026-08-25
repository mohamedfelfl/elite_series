import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/auth/cubits/auth_cubit.dart';
import '../../../features/auth/models/user.dart';
import '../../../generated/locale_keys.g.dart';
import '../../cubits/locale_cubit.dart';
import '../../cubits/shell_navigation_cubit.dart';
import '../../router/app_router.gr.dart';
import '../../constants/dimens.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/theme_mask/animated_theme_switch.dart';
import '../../../features/settings/widgets/update_banner.dart';

@RoutePage(name: 'ShellRoute')
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final User? user = authState.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

        if (user == null) return const Scaffold();

        final List<
          ({PageRouteInfo route, NavigationRailDestination destination})
        >
        menuItems = [
          (
            route: const DashboardRoute(),
            destination: NavigationRailDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: Text(LocaleKeys.dashboard.tr(), style: GoogleFonts.cairo()),
            ),
          ),
          if (user.can(UserPermission.manageStudents))
            (
              route: const StudentListRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.people_outline),
                selectedIcon: const Icon(Icons.people),
                label: Text(LocaleKeys.students.tr(), style: GoogleFonts.cairo()),
              ),
            ),
          if (user.can(UserPermission.manageGroups))
            (
              route: const GroupListRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.groups_outlined),
                selectedIcon: const Icon(Icons.groups),
                label: Text(LocaleKeys.groups.tr(), style: GoogleFonts.cairo()),
              ),
            ),
          if (user.can(UserPermission.managePayments))
            (
              route: PaymentListRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.payment_outlined),
                selectedIcon: const Icon(Icons.payment),
                label: Text(
                  LocaleKeys.payments_tracking.tr(),
                  style: GoogleFonts.cairo(),
                ),
              ),
            ),
          if (user.can(UserPermission.manageAttendance))
            (
              route: const QrScannerRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.qr_code_scanner_outlined),
                selectedIcon: const Icon(Icons.qr_code_scanner),
                label: Text(
                  LocaleKeys.qr_attendance.tr(),
                  style: GoogleFonts.cairo(),
                ),
              ),
            ),
          if (user.can(UserPermission.generateQrCards) ||
              user.can(UserPermission.manageStudents))
            (
              route: const QrCardGeneratorRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.badge_outlined),
                selectedIcon: const Icon(Icons.badge),
                label: Text(
                  LocaleKeys.qr_card_generator.tr(),
                  style: GoogleFonts.cairo(),
                ),
              ),
            ),
          if (user.can(UserPermission.viewReports))
            (
              route: const ReportRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.assessment_outlined),
                selectedIcon: const Icon(Icons.assessment),
                label: Text(LocaleKeys.reports.tr(), style: GoogleFonts.cairo()),
              ),
            ),
          if (user.role == UserRole.admin ||
              user.can(UserPermission.manageUsers))
            (
              route: const AdminPanelRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                selectedIcon: const Icon(Icons.admin_panel_settings),
                label: Text(LocaleKeys.admin.tr(), style: GoogleFonts.cairo()),
              ),
            ),
          if (user.role == UserRole.admin ||
              user.can(UserPermission.manageSettings))
            (
              route: const SettingsRoute(),
              destination: NavigationRailDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: Text(LocaleKeys.settings.tr(), style: GoogleFonts.cairo()),
              ),
            ),
        ];

        final List<PageRouteInfo> filteredRoutes = menuItems
            .map((e) => e.route)
            .toList();
        final List<NavigationRailDestination> destinations = menuItems
            .map((e) => e.destination)
            .toList();

        return AutoTabsRouter(
          routes: filteredRoutes,
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);

            return BlocBuilder<ShellNavigationCubit, ShellNavigationState>(
              builder: (context, navState) {
                return Scaffold(
                  extendBody: true,
                  drawer: _buildDrawer(
                    context,
                    isDark,
                    colorScheme,
                    destinations,
                    tabsRouter,
                  ),
                  appBar: AppBar(
                    title: Text(
                      (destinations[tabsRouter.activeIndex].label as Text).data ?? '',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                    centerTitle: false,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: AnimatedThemeSwitch(
                            isDark: isDark,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.language_outlined),
                        onPressed: () => context.read<LocaleCubit>().toggleLanguage(),
                        tooltip: LocaleKeys.language.tr(),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      const UpdateNotificationBanner(),
                      Expanded(
                        child: ResponsiveLayout(
                          isCollapsed: navState.isCollapsed,
                          selectedIndex: tabsRouter.activeIndex,
                          onDestinationSelected: tabsRouter.setActiveIndex,
                          destinations: destinations,
                          leading: Padding(
                            padding: EdgeInsets.all(AppDimens.p8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                if (!navState.isCollapsed) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    LocaleKeys.app_title.tr(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.teacher_name_brand.tr(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          trailing: Flexible(
                            child: SingleChildScrollView(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: AppDimens.p16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          navState.isCollapsed
                                              ? Icons.chevron_right
                                              : Icons.chevron_left,
                                        ),
                                        onPressed: () => context
                                            .read<ShellNavigationCubit>()
                                            .toggleSidebar(),
                                        tooltip: navState.isCollapsed
                                            ? 'Expand'
                                            : 'Collapse',
                                      ),
                                      SizedBox(height: AppDimens.h8),
                                      IconButton(
                                        icon: const Icon(Icons.logout),
                                        onPressed: () =>
                                            context.read<AuthCubit>().logout(),
                                        tooltip: LocaleKeys.logout.tr(),
                                        color: colorScheme.error,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          mobileBody: child,
                          desktopBody: child,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    bool isDark,
    ColorScheme colorScheme,
    List<NavigationRailDestination> destinations,
    TabsRouter tabsRouter,
  ) {
    return Drawer(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: AppDimens.r10,
                            offset: Offset(0, AppDimens.h4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimens.r8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: AppDimens.avatarSizeLarge,
                          height: AppDimens.avatarSizeLarge,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.h12),
                    Text(
                      LocaleKeys.app_title.tr(),
                      style: GoogleFonts.cairo(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      LocaleKeys.teacher_name_brand.tr(),
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: colorScheme.onPrimary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(destinations.length, (int i) {
                final NavigationRailDestination dest = destinations[i];
                final bool isSelected = tabsRouter.activeIndex == i;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.p12,
                    vertical: AppDimens.p4,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimens.r16),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: IconTheme(
                        data: IconThemeData(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          size: isSelected ? 28 : 24,
                        ),
                        child: isSelected ? dest.selectedIcon : dest.icon,
                      ),
                      title: Text(
                        dest.label is Text ? (dest.label as Text).data ?? '' : '',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      selected: isSelected,
                      tileColor: colorScheme.surface,
                      selectedTileColor: colorScheme.primaryContainer.withValues(
                        alpha: 0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r16),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.p16),
                      onTap: () {
                        Navigator.pop(context);
                        tabsRouter.setActiveIndex(i);
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Divider(indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.r16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: colorScheme.error),
                    title: Text(
                      LocaleKeys.logout.tr(),
                      style: GoogleFonts.cairo(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthCubit>().logout();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.language, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        context.read<LocaleCubit>().toggleLanguage();
                      },
                      child: Text(
                        'عربي / EN',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    AnimatedThemeSwitch(
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
