import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../app/cubits/locale_cubit.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/app_router.gr.dart';
import '../../../../app/shared/animations/app_animations.dart';
import '../../../../app/shared/animations/pressable_scale.dart';
import '../../../../app/shared/widgets/theme_mask/animated_theme_switch.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../features/settings/widgets/update_banner.dart';
import '../../../settings/services/device_binding_service.dart';
import '../../cubits/auth_cubit.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final authCubit = context.read<AuthCubit>();
    final hasUsers = await authCubit.hasAnyUser();
    if (!hasUsers && mounted) {
      // Check if a binding sentinel exists — means the app was already
      // set up on another device and the files were copied here.
      final bindingService = getIt<DeviceBindingService>();
      if (bindingService.hasBindingSentinel()) {
        _showAlreadyBoundError();
        return;
      }
      context.router.replaceAll([const SetupWizardRoute()]);
    }
  }

  /// Show an error dialog when app files were copied from a bound device.
  ///
  /// The dialog includes a transfer-code field so the developer can unlock
  /// the app remotely.  Dismissing the dialog exits the application.
  void _showAlreadyBoundError() {
    final transferController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              icon: Icon(
                Icons.shield_rounded,
                color: colorScheme.error,
                size: 48,
              ),
              title: Text(
                LocaleKeys.app_already_bound_title.tr(),
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.app_already_bound_message.tr(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: transferController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.transfer_code.tr(),
                      hintText: LocaleKeys.transfer_code_hint.tr(),
                      errorText: errorText,
                      prefixIcon: const Icon(Icons.vpn_key_rounded),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(LocaleKeys.close_app.tr()),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final code = transferController.text.trim();
                    if (code.isEmpty) {
                      setDialogState(() {
                        errorText = LocaleKeys.required_field.tr();
                      });
                      return;
                    }
                    final bindingService = getIt<DeviceBindingService>();
                    if (bindingService.validateSentinelTransferCode(code)) {
                      // Valid code – remove sentinel and open setup wizard.
                      bindingService.deleteBindingSentinel();
                      Navigator.of(ctx).pop();
                      if (mounted) {
                        context.router
                            .replaceAll([const SetupWizardRoute()]);
                      }
                    } else {
                      setDialogState(() {
                        errorText = LocaleKeys.invalid_transfer_code.tr();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.lock_open_rounded),
                  label: Text(LocaleKeys.transfer.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        child: Column(
          children: [
            const UpdateNotificationBanner(),
            Expanded(
              child: Stack(
                children: [
                  // Background Decorative Blurs
                  Positioned(
                    top: -size.height * 0.1,
                    left: -size.width * 0.1,
                    child: Container(
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.05),
                            blurRadius: 120,
                            spreadRadius: 120,
                          ),
                        ],
                      ),
                    ),
                  ),
            Positioned(
              bottom: -size.height * 0.1,
              right: -size.width * 0.1,
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.tertiary.withValues(alpha: 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.tertiary.withValues(alpha: 0.05),
                      blurRadius: 120,
                      spreadRadius: 120,
                    ),
                  ],
                ),
              ),
            ),
            // Decorative architectural image (only on large screens)
            if (size.width > 1200)
              Positioned(
                top: size.height / 2 - 300,
                right: 48,
                child: Opacity(
                  opacity: 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/login_bg.jpg',
                      width: 400,
                      height: 600,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

            // Top Controls Bar (Language and Theme Switchers)
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Language Switcher Pill
                    PressableScale(
                      onTap: () => context.read<LocaleCubit>().toggleLanguage(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.85)
                              : colorScheme.surfaceContainerLowest.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language_rounded,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.watch<LocaleCubit>().state.languageCode == 'ar'
                                  ? 'English'
                                  : 'العربية',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Animated Theme Switch (Figma day/night with mask reveal)
                    AnimatedThemeSwitch(
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          LocaleKeys.app_title.tr(),
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          LocaleKeys.credentials_hint.tr(),
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Form Card
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            // Fallback to surfaceContainerHighest logic or simple grey variation
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputLabel(
                                  LocaleKeys.username.tr(),
                                  colorScheme,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _usernameController,
                                  autofocus: true,
                                  decoration: _buildInputDecoration(
                                    hintText: LocaleKeys.username_hint.tr(),
                                    icon: Icons.badge_outlined,
                                    colorScheme: colorScheme,
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? LocaleKeys.required_field.tr()
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                _buildInputLabel(
                                  LocaleKeys.password.tr(),
                                  colorScheme,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration:
                                      _buildInputDecoration(
                                        hintText: LocaleKeys.password_hint.tr(),
                                        icon: Icons.lock_outline,
                                        colorScheme: colorScheme,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                        ),
                                      ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? LocaleKeys.required_field.tr()
                                      : null,
                                ),
                                const SizedBox(height: 32),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state.maybeWhen(
                                      loading: () => true,
                                      orElse: () => false,
                                    );
                                    return PressableScale(
                                      onTap: isLoading ? null : _submit,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: isLoading ? null : _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorScheme.primary,
                                            foregroundColor:
                                                colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                16,
                                              ),
                                            ),
                                            elevation: 4,
                                            shadowColor: colorScheme.primary
                                                .withValues(alpha: 0.4),
                                          ),
                                          child: isLoading
                                              ? SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            colorScheme.onPrimary,
                                                      ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      LocaleKeys.sign_in.tr(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Icon(Icons.login),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ).animateSpringEntrance(),

                        const SizedBox(height: 64),

                        // Footer
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Column(
                            children: [
                              Divider(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.2,
                                ),
                                thickness: 1,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                LocaleKeys.developed_by.tr().toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.outline,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                LocaleKeys.developer_name.tr(),
                                style: textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
);
  }

  Widget _buildInputLabel(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: colorScheme.outline.withValues(alpha: 0.5)),
      prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
      filled: true,
      fillColor: ElevationOverlay.applySurfaceTint(
        colorScheme.surface,
        colorScheme.surfaceTint,
        2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
