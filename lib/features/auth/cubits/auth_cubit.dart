import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/user.dart';
import '../../../app/services/database_service.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/constants/app_constants.dart';
import '../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

part 'auth_cubit.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}

class AuthCubit extends Cubit<AuthState> {
  final DatabaseService _databaseService;

  AuthCubit({
    required DatabaseService databaseService,
  }) : _databaseService = databaseService,
       super(const AuthState.initial());

  Future<void> login(String username, String password) async {
    emit(const AuthState.loading());
    try {
      final Database db = await _databaseService.database;

      // First, find the user by username only
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.getUserByUsername,
        [username],
      );
 
      if (results.isEmpty) {
        emit(AuthState.error(LocaleKeys.invalid_credentials.tr()));
        return;
      }

      final Map<String, Object?> row = results.first;
      final String storedHash = row['password_hash'] as String;
      final String? salt = row['salt'] as String?;

      // Hash with salt if available, otherwise plain hash (backward compat)
      final String passwordHash = _hashPassword(password, salt: salt);

      if (passwordHash != storedHash) {
        emit(AuthState.error(LocaleKeys.invalid_credentials.tr()));
        return;
      }

      final User user = User(
        id: row['id'] as int,
        username: row['username'] as String,
        passwordHash: row['password_hash'] as String,
        role: row['role'] == AppConstants.adminRole ? UserRole.admin : UserRole.user,
        permissions: (jsonDecode(row['permissions'] as String) as List)
            .map(
              (p) => UserPermission.values.firstWhere(
                (e) => e.name == p,
                orElse: () => UserPermission.manageStudents,
              ),
            )
            .toList(),
        createdAt: DateTime.tryParse(row['created_at'] as String? ?? ''),
      );

      // If user has no salt, migrate them to salted password
      if (salt == null && user.id != null) {
        await _migrateToCryptedPassword(db, user.id!, password);
      }

      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  void logout() {
    emit(const AuthState.initial());
  }

  /// Hash a password, with optional salt.
  static String _hashPassword(String password, {String? salt}) {
    final String toHash = salt != null ? '$salt$password' : password;
    final List<int> bytes = utf8.encode(toHash);
    return sha256.convert(bytes).toString();
  }

  /// Generate a random 32-char hex salt.
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    return saltBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Hash a password with a new salt. Returns (hash, salt).
  static (String hash, String salt) hashPasswordWithSalt(String password) {
    final salt = generateSalt();
    final hash = _hashPassword(password, salt: salt);
    return (hash, salt);
  }

  /// Migrate an unsalted user to salted password.
  Future<void> _migrateToCryptedPassword(
    Database db,
    int userId,
    String plainPassword,
  ) async {
    final salt = generateSalt();
    final newHash = _hashPassword(plainPassword, salt: salt);
    await db.rawUpdate(
      DBQueries.updateUserAuth,
      [newHash, salt, userId],
    );
  }

  /// Check if any admin user exists (for first-launch detection).
  Future<bool> hasAnyUser() async {
    final Database db = await _databaseService.database;
    final result = await db.rawQuery(DBQueries.countUsers);
    final count = result.first['count'] as int;
    return count > 0;
  }
}
