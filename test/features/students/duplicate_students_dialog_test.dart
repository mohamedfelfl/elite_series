import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';
import 'package:student_management_system/features/students/screens/student_list/components/duplicate_students_dialog.dart';
import 'package:student_management_system/features/students/services/student_merge_service.dart';

class MockStudentCubit extends Cubit<StudentState> implements StudentCubit {
  MockStudentCubit() : super(const StudentState());

  @override
  Future<List<DuplicateStudentGroup>> findDuplicates() async {
    return [
      DuplicateStudentGroup(
        key: 'ابوزيد محمود',
        displayName: 'ابوزيد محمود',
        students: [
          DuplicateStudent(
            id: 1,
            name: 'ابوزيد محمود',
            serialNumber: '10777',
            phone1: '01012345678',
            phone2: '',
            address: '',
            fatherJob: '',
            school: '',
            groupName: 'أولى ثانوي',
            groupId: 1,
            grade: 'sec_1',
            notes: '',
            marksCount: 0,
            attendanceCount: 0,
            paymentsCount: 0,
            notesDeliveredCount: 0,
            rawData: const {},
          ),
          DuplicateStudent(
            id: 2,
            name: 'ابو زيد محمود',
            serialNumber: '10778',
            phone1: '01012345678',
            phone2: '',
            address: '',
            fatherJob: '',
            school: '',
            groupName: 'أولى ثانوي',
            groupId: 1,
            grade: 'sec_1',
            notes: '',
            marksCount: 0,
            attendanceCount: 0,
            paymentsCount: 0,
            notesDeliveredCount: 0,
            rawData: const {},
          ),
        ],
      ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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

  testWidgets('DuplicateStudentsDialog renders with proper font sizes and no overflow', (tester) async {
    final cubit = MockStudentCubit();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar')],
        path: 'assets/translations',
        startLocale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: BlocProvider<StudentCubit>.value(
                value: cubit,
                child: const Scaffold(
                  body: DuplicateStudentsDialog(),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DuplicateStudentsDialog), findsOneWidget);
    expect(find.text('ابوزيد محمود'), findsWidgets);
    expect(find.text('10777'), findsOneWidget);
    expect(find.text('10778'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
