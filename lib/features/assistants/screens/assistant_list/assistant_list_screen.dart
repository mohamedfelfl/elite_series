import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/assistant_cubit.dart';

@RoutePage()
class AssistantListScreen extends StatefulWidget {
  const AssistantListScreen({super.key});

  @override
  State<AssistantListScreen> createState() => _AssistantListScreenState();
}

class _AssistantListScreenState extends State<AssistantListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AssistantCubit>().loadAssistants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.assistants_directory.tr(),
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
            )
          : null,
      body: BlocBuilder<AssistantCubit, AssistantState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.search_hint.tr(),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (v) =>
                            context.read<AssistantCubit>().search(v),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.router.push(AssistantFormRoute()),
                      icon: const Icon(Icons.add),
                      label: Text(LocaleKeys.add_assistant.tr()),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.assistants.isEmpty
                      ? Center(child: Text(LocaleKeys.no_assistants_found.tr()))
                      : ListView.builder(
                          itemCount: state.assistants.length,
                          itemBuilder: (context, index) {
                            final assistant = state.assistants[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: ListTile(
                                title: Text(assistant['name']),
                                subtitle: Text(
                                  '${LocaleKeys.serial_number.tr()}: ${assistant['serial_number']} | ${assistant['phone']}',
                                ),
                                onTap: () => context.router.push(
                                  AssistantDetailRoute(assistant: assistant),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => context.router.push(
                                        AssistantFormRoute(
                                          assistant: assistant,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(assistant),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> assistant) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.delete_assistant.tr()),
        content: Text(
          LocaleKeys.confirm_delete_assistant.tr(args: [assistant['name']]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AssistantCubit>().deleteAssistant(
                assistant['id'] as int,
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              LocaleKeys.delete.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }
}
