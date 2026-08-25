import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../app/shared/animations/app_animations.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/group_cubit.dart';
import 'components/group_card.dart';

@RoutePage()
class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.groups.tr(),
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
            )
          : null,
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (BuildContext context, GroupState state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => context.router.push(GroupFormRoute()),
                    icon: const Icon(Icons.add),
                    label: Text(LocaleKeys.add_group.tr()),
                  ),
                ),
                const SizedBox(height: 16),
                if (state.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.groups.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            LocaleKeys.no_groups_yet.tr(),
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossAxisCount = width > 1200
                              ? 3
                              : width > 800
                              ? 2
                              : 1;
                          final itemWidth =
                              (width - (crossAxisCount - 1) * 16) /
                              crossAxisCount;

                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: List.generate(state.groups.length, (index) {
                              final g = state.groups[index];
                              return SizedBox(
                                width: itemWidth,
                                child: GroupCard(group: g),
                              ).animateStaggeredEntrance(index: index);
                            }),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
