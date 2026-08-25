import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlcipher_library_windows/sqlcipher_library_windows.dart';
import 'package:sqlite3/open.dart' as sqlite_open;

void main() async {
  sqlite_open.open.overrideFor(
    sqlite_open.OperatingSystem.windows,
    openSQLCipherOnWindows,
  );
  sqfliteFfiInit();
  /* final db = */
  await databaseFactoryFfi.openDatabase(
    'student_management.db',
    options: OpenDatabaseOptions(
      onConfigure: (db) async {
        await db.execute(
          "PRAGMA key = 'test'",
        ); // wait we don't know the password...
      },
    ),
  );
}
