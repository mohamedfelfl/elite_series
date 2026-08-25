import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../app/di/injection.dart';
import '../../../../../app/services/database_service.dart';
import '../../../../auth/cubits/auth_cubit.dart';
import '../../../../auth/models/user.dart';

/// Security section with change password.
class SecuritySection extends StatelessWidget {
  final User? currentUser;

  const SecuritySection({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return _buildSettingsCard(context, [
      _buildActionTile(
        context,
        icon: Icons.key,
        title: LocaleKeys.change_password.tr(),
        subtitle: LocaleKeys.change_password_desc.tr(),
        onTap: () => _showChangePasswordDialog(context, currentUser),
      ),
    ]);
  }

  Future<void> _showChangePasswordDialog(
    BuildContext context,
    User? currentUser,
  ) async {
    if (currentUser == null) return;

    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.change_password.tr()),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.current_password.tr(),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? LocaleKeys.required_field.tr()
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.new_password.tr(),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? LocaleKeys.required_field.tr()
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.confirm_new_password.tr(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return LocaleKeys.required_field.tr();
                  }
                  if (v != newPasswordController.text) {
                    return LocaleKeys.passwords_do_not_match.tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final db = await getIt<DatabaseService>().database;
                final userRow = await db.query(
                  'users',
                  columns: ['salt'],
                  where: 'id = ?',
                  whereArgs: [currentUser.id],
                );
                final salt = userRow.isNotEmpty
                    ? userRow.first['salt'] as String?
                    : null;
                final oldToHash = salt != null
                    ? '$salt${oldPasswordController.text}'
                    : oldPasswordController.text;
                final oldHash = sha256
                    .convert(utf8.encode(oldToHash))
                    .toString();
                if (oldHash != currentUser.passwordHash) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.invalid_current_password.tr()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }

                final (newHash, newSalt) = AuthCubit.hashPasswordWithSalt(
                  newPasswordController.text,
                );
                await db.update(
                  'users',
                  {'password_hash': newHash, 'salt': newSalt},
                  where: 'id = ?',
                  whereArgs: [currentUser.id],
                );

                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.password_changed_success.tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: Text(LocaleKeys.change.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: iconColor),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }
}
