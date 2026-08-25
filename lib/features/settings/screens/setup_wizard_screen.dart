import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/di/injection.dart';
import '../../../app/router/app_router.gr.dart';
import '../../../app/services/database_service.dart';
import '../../../generated/locale_keys.g.dart';
import '../../auth/cubits/auth_cubit.dart';
import '../services/device_binding_service.dart';
import '../services/settings_service.dart';

/// First-launch setup wizard.
///
/// Shown when no admin user exists. Guides the user through:
/// 1. Creating an admin account (username + password)
/// 2. Binding the device (hardware fingerprint + license key)
@RoutePage()
class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Admin account
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _step1FormKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Step 2: Device binding
  String _fingerprint = '';
  String _deviceName = '';
  String _osInfo = '';
  bool _isBindingDevice = false;
  bool _deviceBound = false;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final service = getIt<DeviceBindingService>();
    final fingerprint = await service.generateFingerprint();
    setState(() {
      _fingerprint = fingerprint;
      _deviceName = service.getDeviceName();
      _osInfo = service.getOsInfo();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -size.height * 0.08,
            left: -size.width * 0.08,
            child: Container(
              width: size.width * 0.35,
              height: size.width * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.08,
            right: -size.width * 0.08,
            child: Container(
              width: size.width * 0.35,
              height: size.width * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.tertiary.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.tertiary.withValues(alpha: 0.05),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      // Logo & Title
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocaleKeys.setup_welcome.tr(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.setup_subtitle.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          StepItem(
                            icon: Icons.person_add_rounded,
                            label: LocaleKeys.step_account.tr(),
                            isActive: _currentStep >= 0,
                            isCompleted: _currentStep > 0,
                          ),
                          StepLine(isCompleted: _currentStep > 0),
                          StepItem(
                            icon: Icons.phonelink_lock_rounded,
                            label: LocaleKeys.step_device.tr(),
                            isActive: _currentStep >= 1,
                            isCompleted: _currentStep > 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: ElevationOverlay.applySurfaceTint(
                            colorScheme.surface,
                            colorScheme.surfaceTint,
                            1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 420,
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              SingleChildScrollView(
                                child: _buildStep1Account(
                                  colorScheme,
                                  textTheme,
                                ),
                              ),
                              SingleChildScrollView(
                                child: _buildStep2Device(
                                  colorScheme,
                                  textTheme,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _currentStep > 0
                                  ? OutlinedButton(
                                      onPressed: () => setState(() => _currentStep--),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(LocaleKeys.go_back.tr()),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                              elevation: 2,
                              shadowColor: colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _currentStep == 1
                                        ? LocaleKeys.complete_setup.tr()
                                        : LocaleKeys.next.tr(),
                                  ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Account(ColorScheme colorScheme, TextTheme textTheme) {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_admin_account.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.admin_account_desc.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          CustomTextFormField(
            controller: _usernameController,
            labelText: LocaleKeys.username.tr(),
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (v) => v!.isEmpty ? LocaleKeys.username_required.tr() : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            labelText: LocaleKeys.password.tr(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            isPassword: true,
            validator: (v) => v!.isEmpty ? LocaleKeys.password_required.tr() : null,
            onVisibilityToggle: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            labelText: LocaleKeys.confirm_password_hint.tr(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            isPassword: true,
            validator: (v) => v!.isEmpty
                ? LocaleKeys.confirm_your_password.tr()
                : v != _passwordController.text
                    ? LocaleKeys.passwords_do_not_match.tr()
                    : null,
            onVisibilityToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Device(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.bind_to_this_device.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          LocaleKeys.device_restriction_desc.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDeviceInfoRow(Icons.computer, LocaleKeys.device.tr(), _deviceName),
              const SizedBox(height: 12),
              _buildDeviceInfoRow(Icons.info_outline, LocaleKeys.os.tr(), _osInfo),
              const SizedBox(height: 12),
              _buildDeviceInfoRow(
                Icons.fingerprint,
                LocaleKeys.fingerprint.tr(),
                _fingerprint.length > 20
                    ? '${_fingerprint.substring(0, 20)}...'
                    : _fingerprint,
                copyText: _fingerprint,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (_deviceBound)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.device_bound_success.tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBindingDevice ? null : _bindCurrentDevice,
              icon: _isBindingDevice
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock),
              label: Text(LocaleKeys.bind_to_this_device.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceInfoRow(
    IconData icon,
    String label,
    String value, {
    String? copyText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (copyText != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: copyText));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.copied_to_clipboard.tr()),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.copy, size: 16),
            tooltip: LocaleKeys.copy.tr(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: colorScheme.primary,
          ),
        ],
      ],
    );
  }

  Future<void> _nextStep() async {
    if (_currentStep == 0) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) return;
      setState(() => _currentStep = 1);
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentStep == 1) {
      if (!_deviceBound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.bind_device.tr())),
        );
        return;
      }
      await _completeSetup();
    }
  }

  Future<void> _bindCurrentDevice() async {
    setState(() => _isBindingDevice = true);
    try {
      final service = getIt<DeviceBindingService>();
      await service.bindDevice(_fingerprint);
      final licenseKey = service.generateLicenseKey(_fingerprint);
      await service.storeLicenseKey(licenseKey);

      setState(() {
        _deviceBound = true;
        _isBindingDevice = false;
      });
    } catch (e) {
      setState(() => _isBindingDevice = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.failed_to_bind_device.tr(args: [e.toString()]))),
        );
      }
    }
  }

  Future<void> _completeSetup() async {
    setState(() => _isSubmitting = true);

    try {
      final dbService = getIt<DatabaseService>();
      final Database db = await dbService.database;

      final (passwordHash, salt) = AuthCubit.hashPasswordWithSalt(
        _passwordController.text,
      );

      await db.insert('users', {
        'username': _usernameController.text.trim(),
        'password_hash': passwordHash,
        'salt': salt,
        'role': 'admin',
        'permissions': jsonEncode([
          'manageStudents',
          'manageGroups',
          'managePayments',
          'manageAttendance',
          'manageExams',
          'viewReports',
          'manageUsers',
          'manageAssistants',
          'manageNotes',
        ]),
      });

      final settingsService = getIt<SettingsService>();
      await settingsService.setBool(SettingsKeys.setupCompleted, true);

      // Write the binding sentinel alongside the executable so that
      // copying app files to another device will be detected.
      final bindingService = getIt<DeviceBindingService>();
      await bindingService.writeBindingSentinel();

      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.setup_failed.tr(args: [e.toString()]))),
        );
      }
    }
  }
}

class StepItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const StepItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted
                  ? colorScheme.primary
                  : isActive
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHigh,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isCompleted ? Icons.check_rounded : icon,
              color: isCompleted
                  ? colorScheme.onPrimary
                  : isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class StepLine extends StatelessWidget {
  final bool isCompleted;

  const StepLine({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Icon prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onVisibilityToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }
}
