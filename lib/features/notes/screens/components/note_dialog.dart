import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/notes_cubit.dart';
import '../../models/note.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.note?.name ?? '');
    _priceController = TextEditingController(
      text: widget.note?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text) ?? 0.0;

      try {
        if (widget.note == null) {
          await context.read<NotesCubit>().addNote(name, price);
        } else {
          await context.read<NotesCubit>().updateNote(
            widget.note!.id!,
            name,
            price,
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
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return AlertDialog(
      title: Text(
        isEditing ? LocaleKeys.edit_note.tr() : LocaleKeys.add_note.tr(),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.note_name.tr(),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? LocaleKeys.required_field.tr()
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: LocaleKeys.note_price.tr(),
                border: const OutlineInputBorder(),
                prefixText: '${LocaleKeys.currency_symbol.tr()} ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return LocaleKeys.required_field.tr();
                }
                if (double.tryParse(v) == null) {
                  return 'Invalid price'; // Hardcode basic fallback
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        FilledButton(onPressed: _submit, child: Text(LocaleKeys.save.tr())),
      ],
    );
  }
}
