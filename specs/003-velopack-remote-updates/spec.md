# Feature Specification: Remote Application Updates via Velopack

**Feature Branch**: `003-velopack-remote-updates`

**Created**: 2026-08-14

**Status**: Draft

**Input**: User description: "I want to apply remote updates using Velopack"

## Clarifications

### Session 2026-08-14

- Q: What remote update hosting source will be used for distributing Velopack releases? → A: GitHub Releases repository.
- Q: Should background update checks download automatically or prompt the user first? → A: Prompt before download (notify user with version and release notes; download begins only after user clicks to proceed).
- Q: Are updates mandatory or always optional/dismissible? → A: Always optional and dismissible (users can postpone or dismiss notifications without locking application features).
- Q: Is the GitHub release repository public or private? → A: Public GitHub repository (direct unauthenticated HTTPS release checks and package downloads).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic Update Detection and Notification (Priority: P1)

As an application user, I want the system to automatically check for new software updates when launched, so that I am notified when improvements or bug fixes are available without manual effort.

**Why this priority**: Core value of an automated update lifecycle; keeps users on the most reliable, secure, and feature-complete version of the application.

**Independent Test**: Publish or mock a newer version on the update server, launch the application, and verify that the system notifies the user that a new version is available with release information and a prompt to download.

**Acceptance Scenarios**:

1. **Given** an active internet connection and a newer version available on the remote server, **When** the application starts up, **Then** the application detects the update in the background and displays a non-intrusive update notification banner or dialog showing the new version, release notes, and a "Download & Update" action.
2. **Given** an update notification is presented, **When** the user clicks "Download & Update", **Then** the system begins downloading update assets and displays progress.
3. **Given** the application is running the latest available version, **When** the application starts up, **Then** no update notification is displayed and the user experiences no interruptions.
4. **Given** no internet connection or an unreachable remote update server, **When** the background check executes, **Then** the check fails silently without obstructing the user from using the application.

---

### User Story 2 - Manual Update Check and Progress Feedback (Priority: P2)

As an administrator, I want to manually check for updates from the application settings/about screen and see the current version and download progress, so that I have control over when updates are retrieved and can verify my installation status.

**Why this priority**: Provides transparency and on-demand control for users who want to verify their version or manually trigger updates.

**Independent Test**: Navigate to the Settings/About view, click "Check for Updates", observe visual progress indicators during check and download, and receive clear feedback when the process completes or if no update is found.

**Acceptance Scenarios**:

1. **Given** a user is on the Settings or About screen, **When** they click "Check for Updates", **Then** the system displays a loading indicator while querying the remote update repository.
2. **Given** a manual check is completed and no new version is found, **When** the check finishes, **Then** the system displays a message confirming that the application is up to date (displaying the current version number).
3. **Given** a manual check finds an available update, **When** the check completes, **Then** the system presents the new version number, release notes/changelog, and an option to download and apply the update.
4. **Given** an update download is initiated, **When** downloading update assets, **Then** a progress bar indicates download percentage and transfer state.

---

### User Story 3 - Safe Update Application and Restart (Priority: P3)

As an administrator, I want the update to apply safely with an option to restart immediately or on the next launch, ensuring my local student and academic data are preserved without corruption.

**Why this priority**: Prevents work interruption and guarantees zero data loss during version upgrades.

**Independent Test**: Download a new version update, click "Restart to Update", verify that the application restarts cleanly into the new version, and verify all existing student, attendance, group, and payment records remain intact.

**Acceptance Scenarios**:

1. **Given** an update package has finished downloading, **When** the download finishes, **Then** the user is prompted with options to "Restart Now" or "Update on Next Launch".
2. **Given** the user selects "Restart Now", **When** triggered, **Then** the application closes gracefully, applies the update, and automatically reopens running the updated version.
3. **Given** a successful update and restart, **When** the new version opens, **Then** all local database data, encryption keys, and user preferences are fully preserved.

---

### Edge Cases

- **Network interruption during download**: If the internet connection drops while downloading an update, the system MUST pause or abort gracefully, notify the user with a retry option, and not corrupt existing application files.
- **Insufficient disk space**: If the local drive lacks adequate free space to download or unpack the update package, the system MUST display an informative error and cancel the update cleanly.
- **Concurrent app instances**: If another instance or background process is running, the update mechanism MUST ensure safe file replacement without causing partial write locks or corrupted states.
- **Corrupted remote package / checksum failure**: If a downloaded package fails integrity verification, the system MUST discard the package and prompt the user to retry.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST support remote update distribution using the Velopack release framework for desktop releases.
- **FR-002**: The system MUST check for remote updates automatically upon application startup in a non-blocking background task.
- **FR-003**: The system MUST provide a manual "Check for Updates" action accessible in the application (e.g., in Settings / About section).
- **FR-004**: The system MUST display the currently installed application version number clearly in the UI.
- **FR-005**: When an update is detected, the system MUST display the target version number, release notes/changelog, and an explicit action for the user to initiate the download.
- **FR-006**: The system MUST show real-time progress (percentage / status / downloaded size) during update package downloading.
- **FR-007**: The system MUST provide a prompt when the update is ready, offering options to "Restart Now" to apply immediately or "Apply on Exit/Next Launch".
- **FR-008**: The update installation process MUST preserve all existing SQLite databases, encrypted keys, assets, and user configuration settings.
- **FR-009**: The system MUST gracefully handle network timeouts, offline states, and server unreachable errors without crashing or blocking application usage.
- **FR-010**: The remote update endpoint MUST target a public GitHub Releases repository for querying manifests (`releases.win.json`) and downloading update packages without requiring user authentication tokens.
- **FR-011**: All update notifications and prompts MUST be dismissible, allowing users to postpone updates without restricting access to any application features.

### Key Entities *(include if feature involves data)*

- **AppUpdateInfo**: Represents the state and metadata of a software update.
  - `currentVersion`: Semantic version string of the running application (e.g., "1.0.0").
  - `targetVersion`: Semantic version string of the available update (e.g., "1.1.0").
  - `releaseNotes`: Markdown or plain text summary of changes included in the release.
  - `status`: Current lifecycle state (`idle`, `checking`, `available`, `downloading`, `readyToInstall`, `upToDate`, `error`).
  - `downloadProgress`: Float percentage (0 to 100) indicating current download progress.
  - `errorMessage`: Localized error description if the update check or download fails.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Background update check executes without degrading application startup performance (zero UI freezes or lag).
- **SC-002**: 100% of local application data and database records remain intact and accessible after applying an update.
- **SC-003**: In an automated update test, the total time from clicking "Restart Now" to application restart on the new version is under 15 seconds.
- **SC-004**: 100% of network failures or offline states during update checks fail gracefully with zero application crashes.
- **SC-005**: Users receive real-time visual progress feedback during update download with progress updates delivered continuously.

## Assumptions

- The target deployment platform is Windows desktop (utilizing Velopack Windows packaging and update lifecycle).
- The release artifacts (packages and `releases.win.json` / releases manifest) will be hosted on a remote repository (such as GitHub Releases or an HTTPS web host).
- Updates are applied incrementally (delta updates where applicable) or full package downloads as supported by Velopack.
- User data (SQLite database, secure storage, and local files) resides outside the application executable directory in standard user data locations (e.g., AppData), ensuring safe upgrades across version replacements.
