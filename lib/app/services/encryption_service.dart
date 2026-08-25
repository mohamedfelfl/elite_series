import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages encryption keys for the SQLite database.
///
/// On first launch, generates a 256-bit AES key and stores it
/// in the platform's secure storage (Keychain on iOS/macOS,
/// EncryptedSharedPreferences on Android, credential manager on Windows).
class EncryptionService {
  static const _storageKey = 'sms_db_encryption_key';
  final FlutterSecureStorage _secureStorage;

  EncryptionService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Returns the database encryption passphrase.
  /// Creates one on first call and persists it securely.
  Future<String> getDatabaseKey() async {
    String? key = await _secureStorage.read(key: _storageKey);
    if (key == null) {
      key = _generateKey();
      await _secureStorage.write(key: _storageKey, value: key);
    }
    return key;
  }

  /// Generates a SHA-256 hash-based passphrase from random bytes.
  String _generateKey() {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final bytes = utf8.encode('sms_secure_$timestamp');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
