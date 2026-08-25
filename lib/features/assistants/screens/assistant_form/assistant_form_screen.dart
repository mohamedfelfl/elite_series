import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/assistant_cubit.dart';

@RoutePage()
class AssistantFormScreen extends StatefulWidget {
  final Map<String, dynamic>? assistant;

  const AssistantFormScreen({super.key, this.assistant});

  @override
  State<AssistantFormScreen> createState() => _AssistantFormScreenState();
}

class _AssistantFormScreenState extends State<AssistantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _serialCtrl;
  late TextEditingController _phoneCtrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: widget.assistant?['name'] as String? ?? '',
    );
    _serialCtrl = TextEditingController(
      text: widget.assistant?['serial_number'] as String? ?? '',
    );
    _phoneCtrl = TextEditingController(
      text: widget.assistant?['phone'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _serialCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final data = {
        'name': _nameCtrl.text.trim(),
        'serial_number': _serialCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      };

      try {
        if (widget.assistant == null) {
          await context.read<AssistantCubit>().createAssistant(data);
        } else {
          await context.read<AssistantCubit>().updateAssistant(
            widget.assistant!['id'] as int,
            data,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.success.tr()),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.router.popForced();
        }
      } catch (e) {
        if (mounted) {
          String message = e.toString();
          if (message.contains('UNIQUE constraint failed') ||
              message.contains('SqliteException(2067)')) {
            message =
                "${LocaleKeys.assistant_serial_number.tr()} already exists";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.assistant != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? LocaleKeys.edit_assistant.tr()
              : LocaleKeys.add_assistant.tr(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.screenPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppDimens.maxFormWidth),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.name.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? LocaleKeys.required_field.tr()
                        : null,
                  ),
                  SizedBox(height: AppDimens.h16),
                  TextFormField(
                    controller: _serialCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.assistant_serial_number.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? LocaleKeys.required_field.tr()
                        : null,
                  ),
                  SizedBox(height: AppDimens.h16),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.phone_number.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: AppDimens.h32),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        AppDimens.buttonHeight,
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: AppDimens.iconSize20,
                            height: AppDimens.iconSize20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Text(LocaleKeys.save.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
