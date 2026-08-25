class DBQueries {
  // ---------------------------------------------------------------------------
  // Table Names
  // ---------------------------------------------------------------------------
  static const String tableUsers = 'users';
  static const String tableGroups = 'groups';
  static const String tableGroupSchedules = 'group_schedules';
  static const String tableStudents = 'students';
  static const String tablePayments = 'payments';
  static const String tableLessons = 'lessons';
  static const String tableAttendance = 'attendance';
  static const String tableAssistants = 'assistants';
  static const String tableAssistantAttendance = 'assistant_attendance';
  static const String tableExams = 'exams';
  static const String tableExamGroups = 'exam_groups';
  static const String tableMarks = 'marks';
  static const String tableNotes = 'notes';
  static const String tableStudentNotes = 'student_notes';
  static const String tableAppSettings = 'app_settings';
  static const String tableDeviceBinding = 'device_binding';
  static const String tableLoginAttempts = 'login_attempts';

  // ---------------------------------------------------------------------------

  static const String createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      salt TEXT,
      role TEXT NOT NULL DEFAULT 'user',
      permissions TEXT NOT NULL DEFAULT '[]',
      must_change_password INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  static const String createGroupsTable = '''
    CREATE TABLE IF NOT EXISTS groups (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      grade TEXT,
      day_of_week TEXT,
      time TEXT,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  static const String createGroupSchedulesTable = '''
    CREATE TABLE IF NOT EXISTS group_schedules (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      group_id INTEGER NOT NULL,
      day_of_week TEXT NOT NULL,
      time TEXT NOT NULL,
      FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
    )
  ''';

  static const String createStudentsTable = '''
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      serial_number TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      address TEXT NOT NULL DEFAULT '',
      phone1 TEXT NOT NULL DEFAULT '',
      phone2 TEXT NOT NULL DEFAULT '',
      father_job TEXT NOT NULL DEFAULT '',
      school TEXT NOT NULL DEFAULT '',
      previous_teacher TEXT NOT NULL DEFAULT '',
      group_id INTEGER,
      grade TEXT,
      student_status TEXT NOT NULL DEFAULT 'normal',
      attendance_day TEXT,
      notes TEXT NOT NULL DEFAULT '',
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE SET NULL
    )
  ''';

  static const String createPaymentsTable = '''
    CREATE TABLE IF NOT EXISTS payments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_id INTEGER NOT NULL,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      total_amount REAL NOT NULL,
      paid_amount REAL NOT NULL DEFAULT 0,
      paid_date TEXT,
      FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
    )
  ''';

  static const String createLessonsTable = '''
    CREATE TABLE IF NOT EXISTS lessons (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      group_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT,
      title TEXT NOT NULL DEFAULT '',
      status TEXT NOT NULL DEFAULT 'scheduled',
      created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
      FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
    )
  ''';

  static const String createAttendanceTable = '''
    CREATE TABLE IF NOT EXISTS attendance (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lesson_id INTEGER,
      student_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'attended',
      notes TEXT NOT NULL DEFAULT '',
      FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
    )
  ''';

  static const String createAssistantsTable = '''
    CREATE TABLE IF NOT EXISTS assistants (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      serial_number TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      phone TEXT NOT NULL DEFAULT '',
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  static const String createAssistantAttendanceTable = '''
    CREATE TABLE IF NOT EXISTS assistant_attendance (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      assistant_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      type TEXT NOT NULL,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      FOREIGN KEY (assistant_id) REFERENCES assistants(id) ON DELETE CASCADE
    )
  ''';

  static const String createExamsTable = '''
    CREATE TABLE IF NOT EXISTS exams (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      full_mark REAL NOT NULL,
      date TEXT NOT NULL
    )
  ''';

  static const String createExamGroupsTable = '''
    CREATE TABLE IF NOT EXISTS exam_groups (
      exam_id INTEGER NOT NULL,
      group_id INTEGER NOT NULL,
      PRIMARY KEY (exam_id, group_id),
      FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
      FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
    )
  ''';

  static const String createMarksTable = '''
    CREATE TABLE IF NOT EXISTS marks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exam_id INTEGER NOT NULL,
      student_id INTEGER NOT NULL,
      score REAL NOT NULL,
      FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
      UNIQUE(exam_id, student_id)
    )
  ''';

  static const String createNotesTable = '''
    CREATE TABLE IF NOT EXISTS notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  static const String createStudentNotesTable = '''
    CREATE TABLE IF NOT EXISTS student_notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_id INTEGER NOT NULL,
      note_id INTEGER NOT NULL,
      delivered_date TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
      FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
      FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
      UNIQUE(student_id, note_id)
    )
  ''';

  static const String createAppSettingsTable = '''
    CREATE TABLE IF NOT EXISTS app_settings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL,
      updated_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
    )
  ''';

  static const String createDeviceBindingTable = '''
    CREATE TABLE IF NOT EXISTS device_binding (
      id INTEGER PRIMARY KEY,
      device_fingerprint TEXT NOT NULL,
      device_name TEXT,
      os_info TEXT,
      bound_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
    )
  ''';

  static const String createLoginAttemptsTable = '''
    CREATE TABLE IF NOT EXISTS login_attempts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      success INTEGER NOT NULL DEFAULT 0,
      attempted_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
    )
  ''';

  // ---------------------------------------------------------------------------
  // DDL Queries - Indexes
  // ---------------------------------------------------------------------------

  static const String createIdxStudentsGroup =
      'CREATE INDEX IF NOT EXISTS idx_students_group ON students(group_id)';
  static const String createIdxPaymentsStudent =
      'CREATE INDEX IF NOT EXISTS idx_payments_student ON payments(student_id)';
  static const String createIdxAttendanceStudent =
      'CREATE INDEX IF NOT EXISTS idx_attendance_student ON attendance(student_id)';
  static const String createIdxAttendanceDate =
      'CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date)';
  static const String createIdxMarksExam =
      'CREATE INDEX IF NOT EXISTS idx_marks_exam ON marks(exam_id)';
  static const String createIdxMarksStudent =
      'CREATE INDEX IF NOT EXISTS idx_marks_student ON marks(student_id)';
  static const String createIdxGroupSchedulesGroup =
      'CREATE INDEX IF NOT EXISTS idx_group_schedules_group ON group_schedules(group_id)';
  static const String createIdxAssistantAttendanceAssistant =
      'CREATE INDEX IF NOT EXISTS idx_assistant_attendance_assistant ON assistant_attendance(assistant_id)';
  static const String createIdxAssistantAttendanceDate =
      'CREATE INDEX IF NOT EXISTS idx_assistant_attendance_date ON assistant_attendance(date)';
  static const String createIdxLoginAttemptsUsername =
      'CREATE INDEX IF NOT EXISTS idx_login_attempts_username ON login_attempts(username)';
  static const String createIdxLessonsGroup =
      'CREATE INDEX IF NOT EXISTS idx_lessons_group ON lessons(group_id)';
  static const String createIdxLessonsDate =
      'CREATE INDEX IF NOT EXISTS idx_lessons_date ON lessons(date)';
  static const String createIdxLessonsStatus =
      'CREATE INDEX IF NOT EXISTS idx_lessons_status ON lessons(status)';
  static const String createIdxAttendanceLesson =
      'CREATE INDEX IF NOT EXISTS idx_attendance_lesson ON attendance(lesson_id)';

  // ---------------------------------------------------------------------------
  // DDL Queries - Alter Tables
  // ---------------------------------------------------------------------------

  static const String alterUsersAddSalt =
      'ALTER TABLE users ADD COLUMN salt TEXT';
  static const String alterUsersAddMustChangePassword =
      'ALTER TABLE users ADD COLUMN must_change_password INTEGER NOT NULL DEFAULT 0';
  static const String alterGroupsAddGrade =
      'ALTER TABLE groups ADD COLUMN grade TEXT';
  static const String alterStudentsAddGrade =
      'ALTER TABLE students ADD COLUMN grade TEXT';
  static const String alterStudentsAddStatus =
      "ALTER TABLE students ADD COLUMN student_status TEXT NOT NULL DEFAULT 'normal'";
  static const String alterStudentsAddAttendanceDay =
      'ALTER TABLE students ADD COLUMN attendance_day TEXT';
  static const String alterStudentsAddNotes =
      "ALTER TABLE students ADD COLUMN notes TEXT NOT NULL DEFAULT ''";
  static const String alterAttendanceAddLessonId =
      'ALTER TABLE attendance ADD COLUMN lesson_id INTEGER';

  // ---------------------------------------------------------------------------
  // Auth Queries
  // ---------------------------------------------------------------------------

  static const String countUsers = 'SELECT COUNT(*) as count FROM users';
  static const String getUserByUsername = 'SELECT * FROM users WHERE username = ?';
  static const String updateUserAuth = 'UPDATE users SET password_hash = ?, salt = ? WHERE id = ?';

  // ---------------------------------------------------------------------------
  // Student Queries
  // ---------------------------------------------------------------------------

  static const String countStudents = 'SELECT COUNT(*) as cnt FROM students';
  static const String insertStudent = '''
    INSERT INTO students (serial_number, name, address, phone1, phone2, father_job, school, previous_teacher, group_id, grade, student_status, attendance_day, notes)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';
  static const String updateStudent = '''
    UPDATE students SET serial_number = ?, name = ?, address = ?, phone1 = ?, phone2 = ?, father_job = ?, school = ?, previous_teacher = ?, group_id = ?, grade = ?, student_status = ?, attendance_day = ?, notes = ?
    WHERE id = ?
  ''';
  static const String deleteStudent = 'DELETE FROM students WHERE id = ?';
  static const String getStudentsBase = '''
        SELECT s.*, g.name as group_name 
        FROM students s 
        LEFT JOIN groups g ON s.group_id = g.id
  ''';
  static const String deleteMultipleStudentsBase = 'DELETE FROM students WHERE id IN';
  static const String getStudentById = '''
        SELECT s.*, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON s.group_id = g.id
        WHERE s.id = ?
  ''';
  static const String getStudentBySerial = '''
        SELECT s.*, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON s.group_id = g.id
        WHERE s.serial_number = ?
  ''';

  static const String studentSearchCondition = '(s.name LIKE ? OR s.serial_number LIKE ? OR s.phone1 LIKE ?)';
  static const String studentGroupCondition = 's.group_id = ?';
  // ---------------------------------------------------------------------------
  // Report Queries
  // ---------------------------------------------------------------------------

  static const String reportStudentInfo = '''
        SELECT s.*, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON s.group_id = g.id
        WHERE s.id = ?
  ''';
  static const String reportStudentMarks = '''
        SELECT m.score, e.name as exam_name, e.full_mark, e.date
        FROM marks m
        JOIN exams e ON m.exam_id = e.id
        WHERE m.student_id = ?
        ORDER BY e.date DESC
  ''';
  static const String reportStudentAttendance = '''
        SELECT * FROM attendance
        WHERE student_id = ?
        ORDER BY date DESC
  ''';
  static const String reportStudentPayments = '''
        SELECT * FROM payments
        WHERE student_id = ?
        ORDER BY year DESC, month DESC
  ''';
  static const String reportDailyPayments = '''
        SELECT p.*, s.name as student_name, s.serial_number
        FROM payments p
        JOIN students s ON p.student_id = s.id
        WHERE p.paid_date LIKE ?
        ORDER BY s.name ASC
  ''';
  static const String reportHighestMarksBase = '''
        SELECT m.score, s.name as student_name, s.serial_number,
               e.name as exam_name, e.full_mark, e.date
        FROM marks m
        JOIN students s ON m.student_id = s.id
        JOIN exams e ON m.exam_id = e.id
  ''';
  static const String reportAttendanceBase = '''
        SELECT a.date, a.status, a.notes, s.name as student_name, s.serial_number, g.name as group_name
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        LEFT JOIN groups g ON s.group_id = g.id
  ''';

  static const String reportGroupPayments = '''
        SELECT p.*, s.name as student_name, s.serial_number
        FROM payments p
        JOIN students s ON p.student_id = s.id
        WHERE s.group_id = ?
        AND (p.year * 12 + p.month) >= ?
        AND (p.year * 12 + p.month) <= ?
        ORDER BY s.name ASC, p.year ASC, p.month ASC
  ''';
  static const String reportAssistantAttendance = '''
        SELECT * FROM assistant_attendance
        WHERE assistant_id = ?
        ORDER BY date DESC, id DESC
  ''';
  static const String reportNotesDeliveryStudentBase = '''
        SELECT s.*, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON s.group_id = g.id
  ''';

  // ---------------------------------------------------------------------------
  // Dashboard Queries
  // ---------------------------------------------------------------------------

  static const String countGroups = 'SELECT COUNT(*) FROM groups';
  static const String countAssistants = 'SELECT COUNT(*) as cnt FROM assistants';
  static const String countExams = 'SELECT COUNT(*) FROM exams';
  static const String getAssistantsBase = 'SELECT * FROM assistants';
  static const String deleteMultipleAssistantsBase = 'DELETE FROM assistants WHERE id IN';
  
  // ---------------------------------------------------------------------------
  // Exam Queries
  // ---------------------------------------------------------------------------

  static const String calculateAverageScoreTotalMarks = 'SELECT SUM(score) as total FROM marks';
  static const String calculateAverageScoreCountExams = 'SELECT COUNT(*) as count FROM exams';

  static const String getTopStudentsSelect = '''
        SELECT 
          s.id as studentId, 
          s.name as studentName, 
          s.serial_number as serialNumber, 
          SUM(m.score) as totalMarks, 
          SUM(e.full_mark) as totalFullMarks,
          COUNT(m.id) as examCount
        FROM students s
  ''';

  static const String getTopStudentsJoin = '''
        JOIN marks m ON s.id = m.student_id
        JOIN exams e ON m.exam_id = e.id
  ''';

  static const String loadExamStudentsBase = '''
        SELECT s.*, g.name as group_name
        FROM students s
        JOIN exam_groups eg ON s.group_id = eg.group_id
        JOIN groups g ON s.group_id = g.id
        WHERE eg.exam_id = ?
        ORDER BY g.name ASC, s.name ASC
  ''';

  static const String loadMarksBase = '''
        SELECT m.*, s.name as student_name, s.serial_number,
               e.name as exam_name, e.full_mark as exam_full_mark
        FROM marks m
        JOIN students s ON m.student_id = s.id
        JOIN exams e ON m.exam_id = e.id
        WHERE m.exam_id = ?
        ORDER BY m.score DESC
  ''';

  static const String loadStudentMarksBase = '''
        SELECT m.*, e.name as exam_name, e.full_mark as exam_full_mark, e.date as exam_date
        FROM marks m
        JOIN exams e ON m.exam_id = e.id
        WHERE m.student_id = ?
        ORDER BY e.date DESC, m.id DESC
  ''';

  static const String getHighestMarksBase = '''
        SELECT m.*, s.name as student_name, s.serial_number,
               e.name as exam_name, e.full_mark as exam_full_mark
        FROM marks m
        JOIN students s ON m.student_id = s.id
        JOIN exams e ON m.exam_id = e.id
  ''';
  static const String examDateRangeCondition = 'e.date BETWEEN ? AND ?';
  static const String examIdCondition = 'e.id = ?';
  static const String markScoreMinCondition = 'm.score >= ?';
  static const String markScoreMaxCondition = 'm.score <= ?';
  static const String examFromDateCondition = 'e.date >= ?';
  static const String examToDateCondition = 'e.date <= ?';
  static const String examGroupJoinFragment = 'JOIN exam_groups eg ON e.id = eg.exam_id AND eg.group_id = s.group_id';
  
  // ---------------------------------------------------------------------------
  // Group Queries
  // ---------------------------------------------------------------------------

  static const String loadGroupsWithStudentCount = '''
        SELECT g.*, COUNT(s.id) as student_count
        FROM groups g
        LEFT JOIN students s ON s.group_id = g.id
        GROUP BY g.id
        ORDER BY g.name ASC
  ''';

  static const String loadAvailableStudentsBase = 'SELECT * FROM students WHERE group_id IS NULL';
  static const String getGroupSchedulesByGroupId = 'SELECT * FROM group_schedules WHERE group_id = ?';
  static const String deleteGroupSchedulesByGroupId = 'DELETE FROM group_schedules WHERE group_id = ?';
  static const String availableStudentsSearchCondition = ' AND (name LIKE ? OR serial_number LIKE ?)';

  // ---------------------------------------------------------------------------
  // Lesson & Attendance Queries
  // ---------------------------------------------------------------------------

  static const String loadLessonsForDate = '''
        SELECT l.*, g.name as group_name,
          (SELECT COUNT(*) FROM students s WHERE s.group_id = l.group_id) as enrolled_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'attended') as attended_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'otherLesson') as other_group_count
        FROM lessons l
        JOIN groups g ON l.group_id = g.id
        WHERE l.date = ?
        ORDER BY l.start_time ASC, l.id ASC
  ''';

  static const String loadLessonById = '''
        SELECT l.*, g.name as group_name,
          (SELECT COUNT(*) FROM students s WHERE s.group_id = l.group_id) as enrolled_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'attended') as attended_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'otherLesson') as other_group_count
        FROM lessons l
        JOIN groups g ON l.group_id = g.id
        WHERE l.id = ?
  ''';

  static const String loadLessonAttendance = '''
        SELECT a.*, s.name as student_name, s.serial_number, s.phone1, s.phone2, s.father_job, g.name as group_name
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        LEFT JOIN groups g ON s.group_id = g.id
        WHERE a.lesson_id = ?
        ORDER BY a.id DESC
  ''';

  static const String loadEnrolledStudentsForGroup = '''
        SELECT s.*, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON s.group_id = g.id
        WHERE s.group_id = ?
        ORDER BY s.name ASC
  ''';

  static const String reportAbsentStudentsForLesson = '''
        SELECT s.*, g.name as group_name
        FROM students s
        JOIN groups g ON s.group_id = g.id
        WHERE s.group_id = ?
          AND s.id NOT IN (
            SELECT a.student_id FROM attendance a WHERE a.lesson_id = ? AND a.status = 'attended'
          )
        ORDER BY s.name ASC
  ''';

  static const String loadStudentAttendance = '''
        SELECT a.*, s.name as student_name, l.start_time as lesson_time, lg.name as lesson_group_name
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        LEFT JOIN lessons l ON a.lesson_id = l.id
        LEFT JOIN groups lg ON l.group_id = lg.id
        WHERE a.student_id = ?
        ORDER BY a.date DESC, a.id DESC
  ''';

  static const String loadAllAttendance = '''
        SELECT a.*, s.name as student_name, l.start_time as lesson_time, lg.name as lesson_group_name
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        LEFT JOIN lessons l ON a.lesson_id = l.id
        LEFT JOIN groups lg ON l.group_id = lg.id
        ORDER BY a.date DESC, a.id DESC
  ''';

  static const String loadRecentScans = '''
        SELECT a.*, s.name as student_name 
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        ORDER BY a.id DESC LIMIT 5
  ''';

  static const String getGroupsToday = '''
        SELECT g.id as group_id, g.name, gs.time 
        FROM group_schedules gs
        JOIN groups g ON gs.group_id = g.id
        WHERE gs.day_of_week IN (?, ?, ?)
  ''';

  // ---------------------------------------------------------------------------
  // Payment Queries
  // ---------------------------------------------------------------------------

  static const String loadDailyPaymentsBase = '''
        SELECT p.*, s.name as student_name
        FROM payments p
        JOIN students s ON p.student_id = s.id
        WHERE p.paid_date LIKE ?
        ORDER BY p.paid_date DESC
  ''';

  // ---------------------------------------------------------------------------
  // Export Queries
  // ---------------------------------------------------------------------------

  static const String exportStudentsCsv = '''
        SELECT s.*, g.name as group_name 
        FROM students s 
        LEFT JOIN groups g ON s.group_id = g.id 
        ORDER BY s.name
  ''';

  static const String exportPaymentsCsv = '''
        SELECT p.*, s.name as student_name, s.serial_number 
        FROM payments p 
        JOIN students s ON p.student_id = s.id 
        ORDER BY p.year DESC, p.month DESC
  ''';

  static const String exportAttendanceCsv = '''
        SELECT a.date, l.start_time as lesson_time, lg.name as lesson_group,
               s.serial_number, s.name as student_name, sg.name as student_group,
               a.status, a.notes
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        LEFT JOIN groups sg ON s.group_id = sg.id
        LEFT JOIN lessons l ON a.lesson_id = l.id
        LEFT JOIN groups lg ON l.group_id = lg.id
        ORDER BY a.date DESC, a.id DESC
  ''';

  static const String exportMarksCsv = '''
        SELECT m.*, s.name as student_name, s.serial_number, e.name as exam_name, e.full_mark 
        FROM marks m 
        JOIN students s ON m.student_id = s.id 
        JOIN exams e ON m.exam_id = e.id 
        ORDER BY e.date DESC
  ''';

  static const String dashboardAttendanceStats = '''
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN status = 'attended' THEN 1 ELSE 0 END) as attended
        FROM attendance
        WHERE date >= ?
  ''';
  static const String dashboardPaymentStats = '''
        SELECT 
          SUM(total_amount) as total_due,
          SUM(paid_amount) as total_paid
        FROM payments
        WHERE month = ? AND year = ?
  ''';
  static const String dashboardUpcomingExams = 'SELECT COUNT(*) FROM exams WHERE date >= ?';
  static const String dashboardRecentAttendance = '''
        SELECT a.*, s.name as student_name
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        ORDER BY a.date DESC, a.id DESC
        LIMIT 5
  ''';
  static const String dashboardRecentPayments = '''
        SELECT p.*, s.name as student_name
        FROM payments p
        JOIN students s ON p.student_id = s.id
        ORDER BY p.paid_date DESC
        LIMIT 5
  ''';

}
