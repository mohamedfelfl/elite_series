import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as p;
import '../../../generated/locale_keys.g.dart';

/// Manages device binding to restrict the app to a single computer.
///
/// Uses hardware fingerprinting (Windows MachineGuid, Linux machine-id, macOS IOPlatformUUID)
/// combined with a license key system for controlled device transfers.
///
/// A `.device_bound` sentinel file is written next to the app executable on
/// first binding.  If the app files are later copied to a different machine
/// (without the DB), the sentinel will still be present and the app will
/// refuse to re-run the setup wizard.
class DeviceBindingService {
  static const _fingerprintKey = 'sms_device_fingerprint';
  static const _licenseKey = 'sms_license_key';
  static const _transferCodeKey = 'sms_transfer_code';
  static const _sentinelFileName = '.device_bound';

  final FlutterSecureStorage _secureStorage;

  DeviceBindingService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Generate a unique hardware fingerprint for this device.
  Future<String> generateFingerprint() async {
    try {
      String rawId = '';

      if (Platform.isWindows) {
        // Read Windows MachineGuid from registry
        final result = await Process.run('reg', [
          'query',
          r'HKLM\SOFTWARE\Microsoft\Cryptography',
          '/v',
          'MachineGuid',
        ]);
        final output = result.stdout.toString();
        final match = RegExp(
          r'MachineGuid\s+REG_SZ\s+(\S+)',
        ).firstMatch(output);
        rawId = match?.group(1) ?? '';
      } else if (Platform.isLinux) {
        final file = File('/etc/machine-id');
        if (await file.exists()) {
          rawId = (await file.readAsString()).trim();
        }
      } else if (Platform.isMacOS) {
        final result = await Process.run('ioreg', [
          '-rd1',
          '-c',
          'IOPlatformExpertDevice',
        ]);
        final output = result.stdout.toString();
        final match = RegExp(
          r'"IOPlatformUUID"\s*=\s*"([^"]+)"',
        ).firstMatch(output);
        rawId = match?.group(1) ?? '';
      } else if (Platform.isAndroid) {
        // For Android, use Build.SERIAL + getprop
        final result = await Process.run('getprop', ['ro.serialno']);
        rawId = result.stdout.toString().trim();
      }

      if (rawId.isEmpty) {
        // Fallback: use hostname + platform
        rawId = '${Platform.localHostname}_${Platform.operatingSystem}';
      }

      // Hash the raw ID to create a consistent fingerprint
      final bytes = utf8.encode('sms_device_$rawId');
      return sha256.convert(bytes).toString();
    } catch (e) {
      if (kDebugMode) {
        print('DeviceBindingService: Error generating fingerprint: $e');
      }
      // Fallback fingerprint
      final bytes = utf8.encode(
        'sms_device_${Platform.localHostname}_${Platform.operatingSystem}',
      );
      return sha256.convert(bytes).toString();
    }
  }

  /// Get the device hostname for display purposes.
  String getDeviceName() {
    try {
      return Platform.localHostname;
    } catch (_) {
      return LocaleKeys.unknown_device.tr();
    }
  }

  /// Get OS info for display purposes.
  String getOsInfo() {
    return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
  }

  /// Store the device fingerprint after initial binding.
  Future<void> bindDevice(String fingerprint) async {
    await _secureStorage.write(key: _fingerprintKey, value: fingerprint);
  }

  /// Read the stored fingerprint.
  Future<String?> getStoredFingerprint() async {
    return _secureStorage.read(key: _fingerprintKey);
  }

  /// Store the license key.
  Future<void> storeLicenseKey(String licenseKey) async {
    await _secureStorage.write(key: _licenseKey, value: licenseKey);
  }

  /// Read the stored license key.
  Future<String?> getStoredLicenseKey() async {
    return _secureStorage.read(key: _licenseKey);
  }

  /// Generate a license key from the fingerprint.
  /// The developer uses this to create a key for the customer.
  String generateLicenseKey(String fingerprint) {
    final bytes = utf8.encode('sms_license_$fingerprint');
    final hash = sha256.convert(bytes).toString();
    // Format as XXXX-XXXX-XXXX-XXXX for readability
    return '${hash.substring(0, 4)}-${hash.substring(4, 8)}-${hash.substring(8, 12)}-${hash.substring(12, 16)}'
        .toUpperCase();
  }

  /// Validate a license key against the device fingerprint.
  bool validateLicenseKey(String licenseKey, String fingerprint) {
    final expected = generateLicenseKey(fingerprint);
    return licenseKey.toUpperCase() == expected.toUpperCase();
  }

  /// Validate a developer transfer code.
  /// The transfer code is a special code that allows unbinding from the current device.
  bool validateTransferCode(String transferCode, String currentFingerprint) {
    // The transfer code is generated by the developer using a master secret
    String generatedCode = _generateTransferCode(currentFingerprint);
    debugPrint('Generated Transfer Code: $generatedCode');

    // Normalize both codes by removing whitespace and dashes
    final normalizedInput = transferCode
        .replaceAll('-', '')
        .trim()
        .toUpperCase();
    final normalizedExpected = generatedCode
        .replaceAll('-', '')
        .trim()
        .toUpperCase();

    return normalizedInput == normalizedExpected;
  }

  /// Generate the transfer code for a given fingerprint.
  /// This would normally be done by the developer on their end.
  String _generateTransferCode(String fingerprint) {
    final bytes = utf8.encode('sms_transfer_master_${fingerprint}_2026');
    final hash = sha256.convert(bytes).toString();

    return '${hash.substring(0, 4)}-${hash.substring(4, 8)}-${hash.substring(8, 12)}'
        .toUpperCase();
  }

  /// Check if the device is bound.
  Future<bool> isDeviceBound() async {
    final storedFingerprint = await getStoredFingerprint();
    return storedFingerprint != null && storedFingerprint.isNotEmpty;
  }

  /// Verify current device matches the bound device.
  Future<DeviceBindingStatus> verifyBinding() async {
    final storedFingerprint = await getStoredFingerprint();

    if (storedFingerprint == null || storedFingerprint.isEmpty) {
      return DeviceBindingStatus.unbound;
    }

    final currentFingerprint = await generateFingerprint();
    if (currentFingerprint == storedFingerprint) {
      return DeviceBindingStatus.bound;
    } else {
      return DeviceBindingStatus.mismatch;
    }
  }

  /// Unbind the current device (used during transfer).
  Future<void> unbindDevice() async {
    await _secureStorage.delete(key: _fingerprintKey);
    await _secureStorage.delete(key: _licenseKey);
    await _secureStorage.delete(key: _transferCodeKey);
    await deleteBindingSentinel();
  }

  // ─── SENTINEL FILE (anti-copy protection) ───

  /// Get the path to the sentinel file next to the running executable.
  File _getSentinelFile() {
    final exeDir = p.dirname(Platform.resolvedExecutable);
    return File(p.join(exeDir, _sentinelFileName));
  }

  /// Write a `.device_bound` marker file alongside the executable.
  ///
  /// This file is intentionally placed with the app binaries so it gets
  /// copied if someone duplicates the installation folder.  On the new
  /// machine the DB will be empty (fresh), but the sentinel will still
  /// be present, allowing the app to detect the unauthorized copy.
  Future<void> writeBindingSentinel() async {
    try {
      final file = _getSentinelFile();
      final fingerprint = await generateFingerprint();
      await file.writeAsString(fingerprint);
      await _hideSentinelFile(file);
      if (kDebugMode) {
        print('DeviceBindingService: Sentinel written at ${file.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DeviceBindingService: Failed to write sentinel: $e');
      }
    }
  }

  /// Hide the sentinel file so it is not easily visible to users.
  Future<void> _hideSentinelFile(File file) async {
    try {
      if (Platform.isWindows) {
        // Mark the file as Hidden + System on Windows.
        await Process.run('attrib', ['+h', '+s', file.path]);
      }
      // On Linux/macOS the dot-prefix already hides it from default listings.
    } catch (e) {
      if (kDebugMode) {
        print('DeviceBindingService: Failed to hide sentinel: $e');
      }
    }
  }

  /// Read the fingerprint stored inside the sentinel file.
  ///
  /// Returns `null` when the file does not exist or cannot be read.
  String? readSentinelFingerprint() {
    try {
      final file = _getSentinelFile();
      if (file.existsSync()) {
        return file.readAsStringSync().trim();
      }
    } catch (_) {}
    return null;
  }

  /// Validate a developer transfer code against the fingerprint that was
  /// stored in the sentinel file (i.e. the *original* bound device).
  bool validateSentinelTransferCode(String transferCode) {
    final sentinelFp = readSentinelFingerprint();
    if (sentinelFp == null || sentinelFp.isEmpty) return false;
    return validateTransferCode(transferCode, sentinelFp);
  }

  /// Check whether the binding sentinel file exists alongside the executable.
  bool hasBindingSentinel() {
    try {
      return _getSentinelFile().existsSync();
    } catch (_) {
      return false;
    }
  }

  /// Delete the sentinel file (called during device transfer).
  Future<void> deleteBindingSentinel() async {
    try {
      final file = _getSentinelFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('DeviceBindingService: Failed to delete sentinel: $e');
      }
    }
  }
}

/// Status of device binding verification.
enum DeviceBindingStatus {
  /// Device is not bound yet (first launch).
  unbound,

  /// Device fingerprint matches — authorized.
  bound,

  /// Device fingerprint does NOT match — unauthorized.
  mismatch,
}
