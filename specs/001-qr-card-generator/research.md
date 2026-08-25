# Research & Architectural Decisions: QR Card Generator

## 1. Feature Architecture & Project Structure

- **Decision**: Implement the feature using Clean Architecture / Feature-First structure placed under `lib/features/qr_card_generator/`.
- **Rationale**: Matches the established pattern across all existing features in `lib/features/` (e.g., `students`, `groups`, `attendance`, `payments`).
- **Structure**:
  ```text
  lib/features/qr_card_generator/
  ├── cubits/
  │   ├── qr_card_cubit.dart
  │   └── qr_card_state.dart
  ├── models/
  │   ├── qr_card_config.dart
  │   └── student_card_data.dart
  ├── presentation/
  │   ├── screens/
  │   │   └── qr_card_generator_screen.dart
  │   └── widgets/
  │       ├── qr_card_preview_panel.dart
  │       ├── qr_card_template_widget.dart
  │       ├── student_selection_panel.dart
  │       └── qr_card_control_bar.dart
  └── services/
      └── qr_card_export_service.dart
  ```

## 2. Card Template & Layout Rendering

- **Decision**: Build a specialized Flutter widget `QrCardTemplateWidget` that accurately reproduces the Eagle Monitor card design token layout in 3:2 aspect ratio.
- **Rationale**:
  - **Left Branding Banner**: Light/dark blue container with Eagle logo image asset, "The Legendary Eagle" header, teacher name ("Ali Sabry"), and gold rounded badge ("EAGLE MONITOR ID").
  - **Right Info Section**: White background panel containing student Arabic full name, grade/stage ("المرحلة"), group schedule ("المجموعة"), dynamic QR code (`QrImageView` from `qr_flutter`), "SCAN FOR ATTENDANCE" text, and bottom navy bar (`#0B1B3D`) with student code ("EM000001") and label ("بطاقة تعريف الطالب").
- **Alternatives Considered**: Direct canvas drawing (rejected: too hard to maintain and style compared to declarative Flutter widget tree).

## 3. High-Resolution Image Export (PNG/JPEG)

- **Decision**: Use `RenderRepaintBoundary` with `ui.Image.toByteData(format: ImageByteFormat.png)` combined with background offscreen rendering for batch export.
- **Rationale**: Allows 1:1 pixel-accurate rendering of the exact Flutter card widget at 3.0x pixel ratio (300 DPI equivalent) for high quality printable image output.
- **Batch Processing Strategy**:
  - For single selection: Prompt user for save file path via `file_picker` or save to user's Pictures/Downloads directory.
  - For bulk selection (Group, Stage, All): Prompt for output folder path, then asynchronously process and save `<StudentCode>_<Name>.png` files displaying a progress indicator.

## 4. Navigation & Shell Integration

- **Decision**: Add `QR Card Generator` as a top-level tab in `ShellNavigationCubit` and `ShellScreen` / `AppRouter`.
- **Rationale**: Follows the application's existing main navigation shell pattern (alongside Dashboard, Students, Groups, Attendance, Payments, Exams, Reports, Settings).
