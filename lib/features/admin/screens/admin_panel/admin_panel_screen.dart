import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../auth/models/user.dart';
import '../../cubits/admin_cubit.dart';
import 'components/user_tile.dart';

@RoutePage()
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (BuildContext context, AdminState state) {
        return Scaffold(
          appBar: context.router.canPop()
              ? AppBar(
                  title: Text(LocaleKeys.admin_panel.tr()),
                  centerTitle: true,
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => context.router.push(UserFormRoute()),
                    icon: const Icon(Icons.person_add),
                    label: Text(LocaleKeys.add_user.tr()),
                  ),
                ),
                const SizedBox(height: 24),
                if (state.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final User user = state.users[index];
                          return UserTile(user: user);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
