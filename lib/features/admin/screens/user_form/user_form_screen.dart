import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../auth/models/user.dart';
import '../../cubits/admin_cubit.dart';

@RoutePage()
class UserFormScreen extends StatefulWidget {
  final int? id;
  const UserFormScreen({super.key, this.id});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.user;
  final Set<UserPermission> _selectedPermissions = <UserPermission>{};
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _isEditing = true;
      _loadUser();
    }
  }

  void _loadUser() {
    final List<User> users = context.read<AdminCubit>().state.users;
    final User? user = users.where((User u) => u.id == widget.id).firstOrNull;
    if (user != null) {
      _usernameController.text = user.username;
      _selectedRole = user.role;
      _selectedPermissions.addAll(user.permissions);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.router.maybePop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEditing
                            ? LocaleKeys.edit_user.tr()
                            : LocaleKeys.add_user.tr(),
                        style: textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.username.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? LocaleKeys.required_field.tr()
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _isEditing
                          ? LocaleKeys.new_password_optional.tr()
                          : LocaleKeys.password.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: (v) => !_isEditing && (v == null || v.isEmpty)
                        ? LocaleKeys.required_field.tr()
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Role selection
                  Text(LocaleKeys.role.tr(), style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<UserRole>(
                    segments: [
                      ButtonSegment(
                        value: UserRole.admin,
                        label: Text(LocaleKeys.admin_role.tr()),
                      ),
                      ButtonSegment(
                        value: UserRole.user,
                        label: Text(LocaleKeys.user_role.tr()),
                      ),
                    ],
                    selected: {_selectedRole},
                    onSelectionChanged: (roles) {
                      setState(() {
                        _selectedRole = roles.first;
                        if (_selectedRole == UserRole.admin) {
                          _selectedPermissions.clear();
                          _selectedPermissions.addAll(UserX.allowedPermissions);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Permissions
                  Text(
                    LocaleKeys.permissions.tr(),
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: UserX.allowedPermissions.map((UserPermission perm) {
                      final bool isSelected = _selectedPermissions.contains(
                        perm,
                      );
                      return FilterChip(
                        label: Text(perm.localizedName),
                        selected: isSelected,
                        onSelected: _selectedRole == UserRole.admin
                            ? null
                            : (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedPermissions.add(perm);
                                  } else {
                                    _selectedPermissions.remove(perm);
                                  }
                                });
                              },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        _isEditing
                            ? LocaleKeys.update.tr()
                            : LocaleKeys.create.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final AdminCubit adminCubit = context.read<AdminCubit>();

    if (_isEditing) {
      await adminCubit.updateUser(
        id: widget.id!,
        username: _usernameController.text.trim(),
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
        role: _selectedRole,
        permissions: _selectedPermissions.toList(),
      );
    } else {
      await adminCubit.createUser(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        permissions: _selectedRole == UserRole.admin
            ? UserX.allowedPermissions
            : _selectedPermissions.toList(),
      );
    }

    if (mounted) {
      context.router.maybePop();
    }
  }
}
