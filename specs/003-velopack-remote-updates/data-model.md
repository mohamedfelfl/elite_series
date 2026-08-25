# Data Model: Remote Application Updates via Velopack

**Feature**: Remote Application Updates via Velopack
**Branch**: `003-velopack-remote-updates`
**Date**: 2026-08-14

## Entities & Models

### 1. `AppUpdateInfo`

Represents release metadata and update status retrieved from the remote repository.

| Field | Type | Description |
|-------|------|-------------|
| `currentVersion` | `String` | Version of the currently running application instance (e.g. `1.0.0`) |
| `targetVersion` | `String` | Semantic version string of the available update (e.g. `1.1.0`) |
| `releaseNotes` | `String?` | Changelog / markdown release description from GitHub Releases |
| `packageSize` | `int?` | Approximate download size in bytes |
| `isMandatory` | `bool` | Flag indicating whether update is forced (default: `false`) |
| `publishedAt` | `DateTime?` | Timestamp when the release was published |

---

### 2. `UpdateStatus` (Enum / State Hierarchy)

Represents the state of the update lifecycle managed by `UpdateCubit`.

```text
       ┌───────────────┐
       │     idle      │
       └───────┬───────┘
               │ (check triggered)
       ┌───────▼───────┐
       │   checking    │
       └───┬───────┬───┘
 (up-to-date) │       │ (update found)
  ┌────────▼──┐   ┌───▼───────────┐
  │  upToDate │   │   available   │
  └───────────┘   └───┬───────────┘
                      │ (user clicks download)
                  ┌───▼───────────┐
                  │  downloading  │◄── (progress stream)
                  └───┬───────────┘
                      │ (download complete)
                  ┌───▼───────────┐
                  │ readyToInstall│
                  └───┬───────────┘
                      │ (restart app)
                  ┌───▼───────────┐
                  │  restarting   │
                  └───────────────┘
```

| State | Properties | Description |
|-------|------------|-------------|
| `UpdateInitial` | `currentVersion: String` | Initial state on app boot before any check |
| `UpdateChecking` | `isManual: bool` | Actively querying remote release manifest |
| `UpdateUpToDate` | `currentVersion: String, isManual: bool` | App is on the latest version |
| `UpdateAvailable` | `info: AppUpdateInfo, isManual: bool` | New release discovered, awaiting user download action |
| `UpdateDownloading`| `info: AppUpdateInfo, progress: double` | Downloading update files with progress (0.0 to 1.0) |
| `UpdateReadyToInstall` | `info: AppUpdateInfo` | Assets downloaded and verified, ready for restart |
| `UpdateRestarting` | `info: AppUpdateInfo` | Graceful process termination and Velopack restart |
| `UpdateError` | `message: String, isManual: bool` | Network or manifest error during check/download |

---

### 3. Local Storage / Preference Keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `auto_check_updates` | `bool` | `true` | Setting to enable/disable background check on startup |
| `last_update_check` | `String (ISO8601)` | `null` | Timestamp of the most recent check |
| `dismissed_update_version` | `String?` | `null` | Target version dismissed by user during session |
