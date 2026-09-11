import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/features/students/screens/student_list/components/empty_student_state.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_batch_action_bar.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_card_list.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_data_table.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_list_banner.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_search_header.dart';
import 'package:student_management_system/features/students/screens/student_list/components/student_ui_helper.dart';

import 'package:student_management_system/generated/codegen_loader.g.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const channel = MethodChannel('plugins.flutter.io/shared_preferences');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      return true;
    });
    await EasyLocalization.ensureInitialized();
  });

  Widget buildTestableWidget(Widget child, {Size size = const Size(800, 600)}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, _) {
              return MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: Scaffold(
                  body: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  test('StudentUIHelper provides correct initials and grade labels', () {
    expect(StudentUIHelper.getInitials('Mohamed Ali'), 'MA');
    expect(StudentUIHelper.getInitials('Ali'), 'A');
    expect(StudentUIHelper.getInitials(''), '?');
    expect(StudentUIHelper.getAvatarColor('Mohamed'), isA<Color>());
  });

  testWidgets('StudentBatchActionBar renders correctly and triggers callbacks',
      (tester) async {
    bool toggleAllCalled = false;
    bool clearSelectionCalled = false;
    bool deleteCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        StudentBatchActionBar(
          selectedCount: 2,
          totalCount: 5,
          onToggleAll: () => toggleAllCalled = true,
          onClearSelection: () => clearSelectionCalled = true,
          onDeletePressed: () => deleteCalled = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

    // Verify merge icon is NOT present in batch action bar
    expect(find.byIcon(Icons.merge_type_rounded), findsNothing);

    // Tap toggle all
    await tester.tap(find.byType(Checkbox));
    expect(toggleAllCalled, isTrue);

    // Tap clear selection
    await tester.tap(find.byIcon(Icons.close_rounded));
    expect(clearSelectionCalled, isTrue);

    // Tap delete
    await tester.tap(find.byIcon(Icons.delete_sweep_rounded));
    expect(deleteCalled, isTrue);
  });

  testWidgets('StudentSearchHeader does not overflow on narrow mobile screen',
      (tester) async {
    final controller = TextEditingController(text: 'Ahmed');

    await tester.pumpWidget(
      buildTestableWidget(
        StudentSearchHeader(
          searchController: controller,
          onSearchChanged: (_) {},
          onClearSearch: () {},
          selectedGrade: 'sec_1',
          onGradeChanged: (_) {},
          selectedGroupId: null,
          onGroupChanged: (_) {},
          groups: const [
            {'id': 1, 'name': 'Sunday Group'},
            {'id': 2, 'name': 'Friday Group'},
          ],
          rowsPerPage: 10,
          onRowsPerPageChanged: (_) {},
          onResetAllFilters: () {},
          hasActiveFilters: true,
        ),
        size: const Size(360, 600), // Narrow mobile width
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FilterChip), findsWidgets);
    expect(find.byType(ActionChip), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('StudentListBanner displays total students and triggers add',
      (tester) async {
    bool addPressed = false;

    await tester.pumpWidget(
      buildTestableWidget(
        StudentListBanner(
          totalStudents: 150,
          filteredStudents: 25,
          isFiltered: true,
          onAddPressed: () => addPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('150'), findsOneWidget);
    expect(find.textContaining('25'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_add_rounded));
    expect(addPressed, isTrue);
  });

  testWidgets('StudentCardList renders cards on mobile and allows selection',
      (tester) async {
    final students = [
      {
        'id': 101,
        'name': 'Ahmed Hassan',
        'serial_number': 'SEC1-001',
        'phone1': '01012345678',
        'phone2': '',
        'school': 'Victory College',
        'grade': 'sec_1',
        'group_name': 'Group A',
        'student_status': 'normal',
      },
    ];

    int? toggledId;

    await tester.pumpWidget(
      buildTestableWidget(
        StudentCardList(
          students: students,
          selectedIds: const {},
          onToggleSelection: (id) => toggledId = id,
          onDeleteStudent: (_) {},
        ),
        size: const Size(380, 700),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ahmed Hassan'), findsOneWidget);
    expect(find.text('SEC1-001'), findsOneWidget);
    expect(find.text('01012345678'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    expect(toggledId, equals(101));
  });

  testWidgets('EmptyStudentState shows appropriate CTA for filtered vs empty DB',
      (tester) async {
    bool clearClicked = false;
    bool addClicked = false;

    // 1. Filtered state
    await tester.pumpWidget(
      buildTestableWidget(
        EmptyStudentState(
          isFiltered: true,
          onClearFilters: () => clearClicked = true,
          onAddStudent: () => addClicked = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.filter_alt_off_rounded));
    expect(clearClicked, isTrue);

    // 2. Empty DB state
    await tester.pumpWidget(
      buildTestableWidget(
        EmptyStudentState(
          isFiltered: false,
          onClearFilters: () => clearClicked = true,
          onAddStudent: () => addClicked = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    await tester.tap(find.byIcon(Icons.person_add_rounded));
    expect(addClicked, isTrue);
  });

  testWidgets('StudentSearchHeader density toggle triggers callback',
      (tester) async {
    bool? toggledDensity;

    await tester.pumpWidget(
      buildTestableWidget(
        StudentSearchHeader(
          searchController: TextEditingController(),
          onSearchChanged: (_) {},
          onClearSearch: () {},
          selectedGrade: null,
          onGradeChanged: (_) {},
          selectedGroupId: null,
          onGroupChanged: (_) {},
          groups: const [],
          rowsPerPage: 10,
          onRowsPerPageChanged: (_) {},
          onResetAllFilters: () {},
          hasActiveFilters: false,
          isDense: true,
          onDensityChanged: (val) => toggledDensity = val,
        ),
        size: const Size(1000, 600),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.density_small_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.density_small_rounded));
    expect(toggledDensity, isFalse);
  });

  testWidgets('StudentDataTable renders in dense mode and sorts columns',
      (tester) async {
    final students = [
      {
        'id': 1,
        'name': 'Boulos',
        'serial_number': 'SEC-002',
        'phone1': '01000000002',
        'phone2': '',
        'grade': 'sec_2',
        'group_name': 'Group Beta',
        'student_status': 'normal',
      },
      {
        'id': 2,
        'name': 'Ahmed',
        'serial_number': 'SEC-001',
        'phone1': '01000000001',
        'phone2': '',
        'grade': 'sec_1',
        'group_name': 'Group Alpha',
        'student_status': 'free',
      },
    ];

    await tester.pumpWidget(
      buildTestableWidget(
        StudentDataTable(
          students: students,
          selectedIds: const {},
          onToggleAll: () {},
          onToggleSelection: (_) {},
          onDeleteStudent: (_) {},
          isDense: true,
        ),
        size: const Size(1000, 600),
      ),
    );
    await tester.pumpAndSettle();

    // Verify both students rendered
    expect(find.text('Boulos'), findsOneWidget);
    expect(find.text('Ahmed'), findsOneWidget);
    expect(find.text('SEC-001'), findsOneWidget);
    expect(find.text('SEC-002'), findsOneWidget);

    // Tap on the Name column header to sort
    await tester.tap(find.text(LocaleKeys.name.tr()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
