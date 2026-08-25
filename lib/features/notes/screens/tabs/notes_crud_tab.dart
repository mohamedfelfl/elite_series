import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../auth/models/user.dart';
import '../../../auth/cubits/auth_cubit.dart';
import '../../cubits/notes_cubit.dart';
import '../../cubits/notes_state.dart';
import '../../models/note.dart';
import '../components/note_dialog.dart';

class NotesCrudTab extends StatelessWidget {
  const NotesCrudTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final canManageNodes = user?.can(UserPermission.manageNotes) ?? false;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: canManageNodes
          ? FloatingActionButton.extended(
              onPressed: () {
                final cubit = context.read<NotesCubit>();
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const NoteDialog(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(LocaleKeys.add_note.tr()),
            )
          : null,
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state.isLoading && state.notes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notes.isEmpty) {
            return Center(
              child: Text(
                'No notes found.', // fallback string or localization
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.menu_book,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    note.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${LocaleKeys.note_price.tr()}: ${note.price.toStringAsFixed(2)} ${LocaleKeys.currency_symbol.tr()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: canManageNodes
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: theme.colorScheme.primary,
                              ),
                              tooltip: LocaleKeys.edit_note.tr(),
                              onPressed: () {
                                final cubit = context.read<NotesCubit>();
                                showDialog(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: NoteDialog(note: note),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: theme.colorScheme.error,
                              ),
                              tooltip: LocaleKeys.delete_note.tr(),
                              onPressed: () => _confirmDelete(context, note),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.delete_note.tr()),
        content: Text(LocaleKeys.are_you_sure_delete_note.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              context.read<NotesCubit>().deleteNote(note.id!);
              Navigator.pop(ctx);
            },
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
  }
}
