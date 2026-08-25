import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../auth/cubits/auth_cubit.dart';
import '../../auth/models/user.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

part 'admin_cubit.freezed.dart';

@freezed
abstract class AdminState with _$AdminState {
  const factory AdminState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    String? error,
  }) = _AdminState;
}

class AdminCubit extends Cubit<AdminState> {
  final DatabaseService _databaseService;

  AdminCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const AdminState());

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableUsers,
        orderBy: 'created_at DESC',
      );
      final users = results
          .map(
            (row) => User(
              id: row['id'] as int,
              username: row['username'] as String,
              passwordHash: row['password_hash'] as String,
              role: row['role'] == 'admin' ? UserRole.admin : UserRole.user,
              permissions: (jsonDecode(row['permissions'] as String) as List)
                  .map(
                    (p) => UserPermission.values.firstWhere(
                      (e) => e.name == p,
                      orElse: () => UserPermission.manageStudents,
                    ),
                  )
                  .toList(),
              createdAt: DateTime.tryParse(row['created_at'] as String? ?? ''),
            ),
          )
          .toList();

      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> createUser({
    required String username,
    required String password,
    required UserRole role,
    required List<UserPermission> permissions,
  }) async {
    try {
      final Database db = await _databaseService.database;

      // Use salted password hashing
      final (hash, salt) = AuthCubit.hashPasswordWithSalt(password);

      await db.insert(DBQueries.tableUsers, <String, Object?>{
        'username': username,
        'password_hash': hash,
        'salt': salt,
        'role': role.name,
        'permissions': jsonEncode(permissions.map((p) => p.name).toList()),
      });
      await loadUsers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateUser({
    required int id,
    String? username,
    String? password,
    UserRole? role,
    List<UserPermission>? permissions,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final Map<String, Object?> updates = <String, Object?>{};
      if (username != null) updates['username'] = username;
      if (password != null) {
        // Use salted password hashing
        final (hash, salt) = AuthCubit.hashPasswordWithSalt(password);
        updates['password_hash'] = hash;
        updates['salt'] = salt;
      }
      if (role != null) updates['role'] = role.name;
      if (permissions != null) {
        updates['permissions'] = jsonEncode(
          permissions.map((p) => p.name).toList(),
        );
      }

      if (updates.isNotEmpty) {
        await db.update(DBQueries.tableUsers, updates, where: 'id = ?', whereArgs: [id]);
        await loadUsers();
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(DBQueries.tableUsers, where: 'id = ?', whereArgs: <Object?>[id]);
      await loadUsers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
