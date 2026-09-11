import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/payments/cubits/payment_cubit.dart';
import 'package:student_management_system/features/settings/services/backup_service.dart';

class _MockDatabaseService extends DatabaseService {
  final Database _db;
  _MockDatabaseService(this._db)
      : super(encryptionService: EncryptionService());

  @override
  Future<Database> get database async => _db;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Free Student Payments and CSV Export Tests', () {
    late Database db;
    late _MockDatabaseService dbService;
    late PaymentCubit paymentCubit;
    late BackupService backupService;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createLessonsTable);
      await db.execute(DBQueries.createAttendanceTable);
      await db.execute(DBQueries.createPaymentsTable);

      // Insert group
      await db.insert(DBQueries.tableGroups, {
        'id': 1,
        'name': 'Group 1',
        'grade': '1st Secondary',
      });

      // Insert normal student
      await db.insert(DBQueries.tableStudents, {
        'id': 1,
        'name': 'Normal Student',
        'serial_number': 'SN001',
        'group_id': 1,
        'student_status': 'normal',
      });

      // Insert free student
      await db.insert(DBQueries.tableStudents, {
        'id': 2,
        'name': 'Free Student',
        'serial_number': 'SN002',
        'group_id': 1,
        'student_status': 'free',
      });

      // Insert lesson
      await db.insert(DBQueries.tableLessons, {
        'id': 1,
        'group_id': 1,
        'date': '2026-09-08',
        'start_time': '10:00 AM',
      });

      // Insert attendance on 2026-09-08 for both
      await db.insert(DBQueries.tableAttendance, {
        'id': 1,
        'lesson_id': 1,
        'student_id': 1,
        'date': '2026-09-08',
        'status': 'attended',
      });
      await db.insert(DBQueries.tableAttendance, {
        'id': 2,
        'lesson_id': 1,
        'student_id': 2,
        'date': '2026-09-08',
        'status': 'attended',
      });

      // Insert payment for normal student
      await db.insert(DBQueries.tablePayments, {
        'id': 1,
        'student_id': 1,
        'month': 9,
        'year': 2026,
        'total_amount': 150.0,
        'paid_amount': 150.0,
        'paid_date': '2026-09-08T11:00:00',
      });

      dbService = _MockDatabaseService(db);
      paymentCubit = PaymentCubit(databaseService: dbService);
      backupService = BackupService(databaseService: dbService);
    });

    tearDown(() async {
      await paymentCubit.close();
      await db.close();
    });

    test('loadDailyPayments includes paid student and free attending student with 0 dues', () async {
      await paymentCubit.loadDailyPayments(DateTime(2026, 9, 8));

      final payments = paymentCubit.state.dailyPayments;
      expect(payments.length, equals(2));

      // Find normal student payment
      final normalPayment = payments.firstWhere((p) => p['student_id'] == 1);
      expect(normalPayment['paid_amount'], equals(150.0));
      expect(normalPayment['student_status'], equals('normal'));

      // Find free student entry
      final freeStudent = payments.firstWhere((p) => p['student_id'] == 2);
      expect(freeStudent['student_name'], equals('Free Student'));
      expect(freeStudent['student_status'], equals('free'));
      expect(freeStudent['paid_amount'], equals(0.0));
      expect(freeStudent['total_amount'], equals(0.0));
    });

    test('exportPaymentsCsv includes Student Status and shows zero dues for free student', () async {
      // Add a payment row for student 2 just in case a historical record existed
      await db.insert(DBQueries.tablePayments, {
        'id': 2,
        'student_id': 2,
        'month': 9,
        'year': 2026,
        'total_amount': 100.0,
        'paid_amount': 50.0,
        'paid_date': '2026-09-08T12:00:00',
      });

      final csv = await backupService.exportPaymentsCsv();
      expect(csv.contains('Student Status'), isTrue);
      expect(csv.contains('"Normal Student","SN001","normal",9,2026,150.0,150.0'), isTrue);
      expect(csv.contains('"Free Student","SN002","free",9,2026,0.0,0.0'), isTrue);
    });

    test('exportAttendanceCsv includes Student Status column', () async {
      final csv = await backupService.exportAttendanceCsv();
      expect(csv.contains('Student Status'), isTrue);
      expect(csv.contains('"Free Student","Group 1","free"'), isTrue);
      expect(csv.contains('"Normal Student","Group 1","normal"'), isTrue);
    });
  });
}
