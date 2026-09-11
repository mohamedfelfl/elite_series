import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/utils/arabic_name_helper.dart';
import 'package:student_management_system/features/students/screens/student_form/components/student_duplicate_warning_card.dart';

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

  testWidgets('StudentDuplicateWarningCard does not overflow on long text or narrow constraints', (tester) async {
    final matches = [
      NameDuplicateMatch(
        student: {
          'name': 'عبد الرحمن محمد عبد الله الإدريسي الطويل جداً',
          'serial_number': 'EL-02-00376-EXTREMELY-LONG-SERIAL-NUMBER-TEST',
          'group_name': 'مجموعة المتفوقين في اللغة العربية المتقدمة جداً',
          'phone1': '01012345678 / 01123456789 / 01234567890',
        },
        matchLevel: NameMatchLevel.normalizedExact,
        similarity: 1.0,
        reasonKey: 'normalized_exact_name_match',
      ),
    ];

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'assets/translations',
        startLocale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        child: Builder(
          builder: (context) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (context, child) {
                return MaterialApp(
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  home: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: 300, // Narrow width to verify layout flex
                        child: StudentDuplicateWarningCard(matches: matches),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify widget rendered and no overflow exceptions were thrown
    expect(find.byType(StudentDuplicateWarningCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
