import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/settings/models/app_update_info.dart';

/// Abstract service contract for checking, downloading, and applying updates.
abstract class UpdateService {
  /// Initializes the update service and caches version info.
  Future<void> initialize({String? updateUrl});

  /// Returns the current application version (e.g. "1.0.0").
  Future<String> getCurrentVersion();

  /// Checks if a new update is available on the remote repository.
  Future<AppUpdateInfo?> checkForUpdate({bool allowDowngrade = false});

  /// Downloads the update package, streaming progress from 0.0 to 1.0.
  Stream<double> downloadUpdate(AppUpdateInfo info);

  /// Applies the update and restarts the application immediately.
  Future<void> applyUpdateAndRestart();

  /// Applies the update when the application exits or is launched next time.
  Future<void> applyUpdateOnExit();
}

/// Production implementation of [UpdateService] communicating with
/// GitHub Releases and applying updates via Velopack's Windows runner.
class VelopackUpdateService implements UpdateService {
  final String owner;
  final String repo;
  final http.Client _httpClient;

  String _cachedVersion = '1.0.0';
  String? _downloadedPackagePath;
  String? _downloadedFileName;
  String? _latestDownloadUrl;

  VelopackUpdateService({
    this.owner = 'mohamedfelfl',
    this.repo = 'student_management_system',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<void> initialize({String? updateUrl}) async {
    try {
      final pkgInfo = await PackageInfo.fromPlatform();
      _cachedVersion = pkgInfo.version;
    } catch (e) {
      debugPrint('[VelopackUpdateService] Failed to load PackageInfo: $e');
    }
  }

  @override
  Future<String> getCurrentVersion() async {
    try {
      final pkgInfo = await PackageInfo.fromPlatform();
      _cachedVersion = pkgInfo.version;
    } catch (_) {}
    return _cachedVersion;
  }

  /// Checks if the running application is an installed Velopack app.
  bool get _isInstalledApp {
    try {
      final currentExeDir = p.dirname(Platform.resolvedExecutable);
      final updateExe = p.normalize(p.join(currentExeDir, '..', 'Update.exe'));
      return File(updateExe).existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AppUpdateInfo?> checkForUpdate({bool allowDowngrade = false}) async {
    final current = await getCurrentVersion();
    final url = Uri.parse('https://api.github.com/repos/$owner/$repo/releases/latest');

    try {
      final response = await _httpClient.get(
        url,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rawTag = data['tag_name'] as String? ?? '';
        final cleanTag = rawTag.replaceAll(RegExp(r'^[vV]'), '').trim();
        final body = data['body'] as String? ?? '';
        final assets = data['assets'] as List<dynamic>? ?? [];

        int? packageSize;
        String? assetDownloadUrl;
        String? targetFileName;

        if (_isInstalledApp) {
          // 1. Prefer full nupkg package (guarantees all binaries exist across any version jump)
          for (final asset in assets) {
            final name = (asset['name'] as String? ?? '').toLowerCase();
            if (name.contains(cleanTag.toLowerCase()) && name.endsWith('full.nupkg')) {
              assetDownloadUrl = asset['browser_download_url'] as String?;
              packageSize = asset['size'] as int?;
              targetFileName = asset['name'] as String?;
              break;
            }
          }

          // 2. Fallback to any full nupkg
          if (assetDownloadUrl == null) {
            for (final asset in assets) {
              final name = (asset['name'] as String? ?? '').toLowerCase();
              if (name.endsWith('full.nupkg')) {
                assetDownloadUrl = asset['browser_download_url'] as String?;
                packageSize = asset['size'] as int?;
                targetFileName = asset['name'] as String?;
                break;
              }
            }
          }

          // 3. Fallback to non-delta nupkg
          if (assetDownloadUrl == null) {
            for (final asset in assets) {
              final name = (asset['name'] as String? ?? '').toLowerCase();
              if (name.endsWith('.nupkg') && !name.endsWith('delta.nupkg')) {
                assetDownloadUrl = asset['browser_download_url'] as String?;
                packageSize = asset['size'] as int?;
                targetFileName = asset['name'] as String?;
                break;
              }
            }
          }
        }

        // For non-installed / standalone apps or fallback: prefer Setup.exe
        if (assetDownloadUrl == null) {
          for (final asset in assets) {
            final name = (asset['name'] as String? ?? '').toLowerCase();
            if (name.contains('setup') && name.endsWith('.exe')) {
              assetDownloadUrl = asset['browser_download_url'] as String?;
              packageSize = asset['size'] as int?;
              targetFileName = asset['name'] as String?;
              break;
            }
          }
        }

        if (assetDownloadUrl == null) {
          for (final asset in assets) {
            final name = (asset['name'] as String? ?? '').toLowerCase();
            if (name.endsWith('.exe') || (name.endsWith('.nupkg') && !name.endsWith('delta.nupkg'))) {
              assetDownloadUrl = asset['browser_download_url'] as String?;
              packageSize = asset['size'] as int?;
              targetFileName = asset['name'] as String?;
              break;
            }
          }
        }

        _latestDownloadUrl = assetDownloadUrl;
        _downloadedFileName = targetFileName;

        if (cleanTag.isNotEmpty && _isNewerVersion(current, cleanTag, allowDowngrade)) {
          return AppUpdateInfo(
            currentVersion: current,
            targetVersion: cleanTag,
            releaseNotes: body.isNotEmpty ? body : 'General improvements and bug fixes.',
            packageSize: packageSize,
            publishedAt: data['published_at'] != null ? DateTime.tryParse(data['published_at']) : null,
          );
        }
      }
    } catch (e) {
      debugPrint('[VelopackUpdateService] checkForUpdate error: $e');
    }
    return null;
  }

  /// Resolves the directory where update packages should be downloaded and staged.
  Future<Directory> _getUpdateDirectory() async {
    try {
      final currentExeDir = p.dirname(Platform.resolvedExecutable);
      
      // For Velopack directory structure (where executable is in <rootDir>/current/),
      // the packages folder is in <rootDir>/packages
      if (p.basename(currentExeDir).toLowerCase() == 'current') {
        final rootDir = p.dirname(currentExeDir);
        final packagesDir = Directory(p.join(rootDir, 'packages'));
        if (!packagesDir.existsSync()) {
          packagesDir.createSync(recursive: true);
        }
        return packagesDir;
      }
    } catch (_) {}
    return await getTemporaryDirectory();
  }

  @override
  Stream<double> downloadUpdate(AppUpdateInfo info) async* {
    final downloadUrl = _latestDownloadUrl;
    if (downloadUrl == null || downloadUrl.isEmpty) {
      // Fallback mock progress for local testing
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        yield i / 10.0;
      }
      return;
    }

    try {
      final uri = Uri.parse(downloadUrl);
      final request = http.Request('GET', uri);
      final response = await _httpClient.send(request);

      if (response.statusCode != 200) {
        throw Exception('Download failed with status code ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? (info.packageSize ?? 0);
      final updateDir = await _getUpdateDirectory();

      final fileName = _downloadedFileName ??
          (p.basename(uri.path).isNotEmpty
              ? p.basename(uri.path)
              : 'StudentManagementSystem-${info.targetVersion}-full.nupkg');

      final updateFile = File(p.join(updateDir.path, fileName));
      final sink = updateFile.openWrite();

      int bytesReceived = 0;
      await for (final chunk in response.stream) {
        sink.add(chunk);
        bytesReceived += chunk.length;
        if (contentLength > 0) {
          final progress = (bytesReceived / contentLength).clamp(0.0, 1.0);
          yield progress;
        }
      }

      await sink.flush();
      await sink.close();

      _downloadedPackagePath = updateFile.path;
      yield 1.0;
    } catch (e) {
      debugPrint('[VelopackUpdateService] Download error: $e');
      rethrow;
    }
  }

  @override
  Future<void> applyUpdateAndRestart() async {
    final pkgPath = _downloadedPackagePath;
    if (pkgPath != null && File(pkgPath).existsSync()) {
      if (!kIsWeb && Platform.isWindows) {
        final currentExeDir = p.dirname(Platform.resolvedExecutable);
        final updateExe = _findUpdateExe();
        final currentPid = pid;

        if (updateExe != null && pkgPath.endsWith('.nupkg')) {
          final isCurrentFolder = p.basename(currentExeDir).toLowerCase() == 'current';
          final rootDir = isCurrentFolder ? p.dirname(currentExeDir) : currentExeDir;

          // Velopack Update.exe global options come before the 'apply' command
          final List<String> updateArgs = [
            '--silent',
          ];
          if (isCurrentFolder) {
            updateArgs.addAll(['--rootDir', rootDir]);
          }
          updateArgs.addAll([
            'apply',
            '--waitPid',
            currentPid.toString(),
            '-p',
            pkgPath,
          ]);

          await Process.start(
            updateExe,
            updateArgs,
            mode: ProcessStartMode.detached,
          );
        } else if (pkgPath.endsWith('.zip')) {
          // Portable ZIP update in-place
          final exePath = Platform.resolvedExecutable;
          final script = 'Start-Sleep -Milliseconds 500; '
              'Wait-Process -Id $currentPid -Timeout 15 -ErrorAction SilentlyContinue; '
              'Expand-Archive -Path "$pkgPath" -DestinationPath "$currentExeDir" -Force; '
              'Remove-Item -Path "$pkgPath" -Force -ErrorAction SilentlyContinue; '
              'Start-Process -FilePath "$exePath"';

          await Process.start(
            'powershell',
            ['-NoProfile', '-NonInteractive', '-WindowStyle', 'Hidden', '-Command', script],
            mode: ProcessStartMode.detached,
          );
        } else if (pkgPath.endsWith('.exe')) {
          // Execute Setup.exe with --silent in detached mode
          await Process.start(
            pkgPath,
            ['--silent', '--waitPid', currentPid.toString()],
            mode: ProcessStartMode.detached,
          );
        }

        // Allow child process to detach cleanly before parent exits
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    exit(0);
  }

  @override
  Future<void> applyUpdateOnExit() async {
    final pkgPath = _downloadedPackagePath;
    if (pkgPath != null && File(pkgPath).existsSync()) {
      if (!kIsWeb && Platform.isWindows) {
        final currentExeDir = p.dirname(Platform.resolvedExecutable);
        final updateExe = _findUpdateExe();
        if (updateExe != null && pkgPath.endsWith('.nupkg')) {
          final isCurrentFolder = p.basename(currentExeDir).toLowerCase() == 'current';
          final rootDir = isCurrentFolder ? p.dirname(currentExeDir) : currentExeDir;

          final List<String> updateArgs = [
            '--silent',
          ];
          if (isCurrentFolder) {
            updateArgs.addAll(['--rootDir', rootDir]);
          }
          updateArgs.addAll([
            'apply',
            '--norestart',
            '-p',
            pkgPath,
          ]);

          await Process.start(
            updateExe,
            updateArgs,
            mode: ProcessStartMode.detached,
          );
        }
      }
    }
  }

  /// Locates Velopack's `Update.exe` in the parent or current directory of an installed app.
  String? _findUpdateExe() {
    try {
      final currentExeDir = p.dirname(Platform.resolvedExecutable);
      final candidate1 = p.normalize(p.join(currentExeDir, '..', 'Update.exe'));
      if (File(candidate1).existsSync()) return candidate1;

      final candidate2 = p.normalize(p.join(currentExeDir, 'Update.exe'));
      if (File(candidate2).existsSync()) return candidate2;
    } catch (_) {}
    return null;
  }

  /// Compares semantic versions (e.g. "1.1.0" > "1.0.0").
  bool _isNewerVersion(String current, String target, bool allowDowngrade) {
    if (allowDowngrade) return current != target;
    try {
      final curParts = current.split('.').map((e) => int.tryParse(e.replaceAll(RegExp(r'\D'), '')) ?? 0).toList();
      final tarParts = target.split('.').map((e) => int.tryParse(e.replaceAll(RegExp(r'\D'), '')) ?? 0).toList();

      while (curParts.length < 3) {
        curParts.add(0);
      }
      while (tarParts.length < 3) {
        tarParts.add(0);
      }

      for (int i = 0; i < 3; i++) {
        if (tarParts[i] > curParts[i]) return true;
        if (tarParts[i] < curParts[i]) return false;
      }
    } catch (_) {}
    return false;
  }
}
