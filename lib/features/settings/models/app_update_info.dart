/// Model representing application software update metadata.
class AppUpdateInfo {
  final String currentVersion;
  final String targetVersion;
  final String? releaseNotes;
  final int? packageSize;
  final bool isMandatory;
  final DateTime? publishedAt;

  const AppUpdateInfo({
    required this.currentVersion,
    required this.targetVersion,
    this.releaseNotes,
    this.packageSize,
    this.isMandatory = false,
    this.publishedAt,
  });

  /// Calculates formatted package size in MB.
  String get formattedSize {
    if (packageSize == null || packageSize! <= 0) return '';
    final mb = packageSize! / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUpdateInfo &&
          runtimeType == other.runtimeType &&
          currentVersion == other.currentVersion &&
          targetVersion == other.targetVersion &&
          releaseNotes == other.releaseNotes &&
          packageSize == other.packageSize &&
          isMandatory == other.isMandatory &&
          publishedAt == other.publishedAt;

  @override
  int get hashCode =>
      currentVersion.hashCode ^
      targetVersion.hashCode ^
      releaseNotes.hashCode ^
      packageSize.hashCode ^
      isMandatory.hashCode ^
      publishedAt.hashCode;

  @override
  String toString() {
    return 'AppUpdateInfo(current: $currentVersion, target: $targetVersion, mandatory: $isMandatory)';
  }
}
