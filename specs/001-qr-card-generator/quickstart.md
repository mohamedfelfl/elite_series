# Quickstart & Verification Guide: QR Card Generator

## 1. Overview

This document outlines the validation procedures to verify that the **QR Card Generator** feature works end-to-end according to the specification.

## 2. Verification Scenarios

### Scenario A: Screen Navigation & Tab Integration
1. Launch the application (`flutter run -d windows` or platform target).
2. Login and inspect the main navigation shell tab bar.
3. Verify that a new **QR Card Generator** tab is visible.
4. Click the tab and verify the split view layout loads cleanly (Preview Panel on left, Student List on right, Control bar on top).

### Scenario B: Filtering & Search Behavior
1. In the QR Card Generator tab, click the selection mode dropdown.
2. Select **Group** -> pick a group from the list. Verify right panel displays only students in that group.
3. Select **Stage** -> pick a stage. Verify right panel updates.
4. Select **Student** and type a student name into the search bar. Verify list filters in real-time.

### Scenario C: Live Preview Verification
1. Click any student row in the right panel.
2. Inspect the left preview panel:
   - Left brand bar: Logo, "The Legendary Eagle", "Ali Sabry", "EAGLE MONITOR ID" badge.
   - Right panel: Arabic Full Name, Stage name, Group title/schedule, dynamic scannable QR code, and bottom navy bar with student code and "بطاقة تعريف الطالب".
3. Verify QR code content using a phone scanner or built-in scanner to confirm it decodes to the student's unique code payload.

### Scenario D: Image Export
1. Select one or more students using the checkboxes in the right panel.
2. Click **"Export Images"** or **"Generate Selected Cards"**.
3. Choose destination folder in file picker dialog.
4. Verify PNG image files are saved cleanly with proper resolution (3.0x scale / 300 DPI equivalent) matching the template.
