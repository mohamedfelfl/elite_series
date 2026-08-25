import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/cubits/auth_cubit.dart';
import '../../../auth/models/user.dart';
import '../../cubits/dashboard_cubit.dart';
import 'components/premium_banner.dart';
import 'components/quick_actions_grid.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  void _navigateAndRefresh(PageRouteInfo route) {
    context.router.push(route).then((_) {
      if (mounted) {
        context.read<DashboardCubit>().loadDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final User? user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: context.router.canPop()
              ? AppBar(
                  title: Text(
                    LocaleKeys.app_title.tr(),
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  centerTitle: true,
                )
              : null,
          body: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.p20,
                vertical: AppDimens.p16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PremiumBanner(
                    state: state,
                    username: user?.username ?? 'Admin',
                  ),
                  SizedBox(height: AppDimens.h32),
                  Text(
                    LocaleKeys.quick_actions.tr(),
                    style: textTheme.titleLarge,
                  ),
                  SizedBox(height: AppDimens.h16),
                  QuickActionsGrid(
                    user: user,
                    onNavigate: _navigateAndRefresh,
                  ),
                  SizedBox(height: AppDimens.h32),
                  SizedBox(height: AppDimens.h24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
