import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../app/router/app_router.gr.dart';
import '../../../../auth/models/user.dart';
import '../../../cubits/admin_cubit.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: user.role == UserRole.admin
                ? colorScheme.primaryContainer
                : colorScheme.secondaryContainer,
            child: Icon(
              user.role == UserRole.admin
                  ? Icons.admin_panel_settings
                  : Icons.person,
              color: user.role == UserRole.admin
                  ? colorScheme.primary
                  : colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 4,
                  children: [
                    Chip(
                      label: Text(
                        user.role == UserRole.admin
                            ? LocaleKeys.admin_role.tr()
                            : LocaleKeys.user_role.tr(),
                        style: textTheme.labelSmall,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    ...user.permissions
                        .where((p) => p.isAllowedFeature)
                        .take(3)
                        .map(
                          (p) => Chip(
                            label: Text(
                              p.localizedName,
                              style: textTheme.labelSmall,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    if (user.permissions
                            .where((p) => p.isAllowedFeature)
                            .length >
                        3)
                      Chip(
                        label: Text(
                          '+${user.permissions.where((p) => p.isAllowedFeature).length - 3}',
                          style: textTheme.labelSmall,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext _) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(LocaleKeys.edit.tr()),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(LocaleKeys.delete.tr()),
              ),
            ],
            onSelected: (String value) {
              if (value == 'edit') {
                context.router.push(UserFormRoute(id: user.id));
              } else if (value == 'delete') {
                _confirmDelete(context, user);
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.delete_user.tr()),
        content: Text(LocaleKeys.confirm_delete_user.tr(args: [user.username])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminCubit>().deleteUser(user.id!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
  }
}
