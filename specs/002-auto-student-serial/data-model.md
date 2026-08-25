# Data Model & Schema: Auto-Generated Student Serial Number

## Student Entity Refinement

### Fields & Validation

| Field | Data Type | Nullable | Validation / Constraints | Description |
|---|---|---|---|---|
| `id` | Integer | No | Primary Key, Auto Increment | Internal unique ID |
| `name` | Text | No | Non-empty string | Student full name |
| `grade` | Text | No | Enum: `['prep_1', 'prep_2', 'prep_3', 'sec_1', 'sec_2', 'sec_3']` | Mandatory academic stage |
| `serial_number` | Text | No | Unique 5-digit formatted string | Auto-generated serial number |

---

## Grade Base Serial Config Mapping

```dart
const Map<String, int> kGradeBaseSerials = {
  'prep_1': 10777,
  'prep_2': 20777,
  'prep_3': 30777,
  'sec_1': 40777,
  'sec_2': 50777,
  'sec_3': 60777,
};
```

---

## Serial Generator Logic Contract

```dart
String generateNextSerial({
  required String grade,
  required List<String> existingSerialsForGrade,
}) {
  final baseSerial = kGradeBaseSerials[grade] ?? 10777;
  int maxSerial = baseSerial - 1;

  for (final serialStr in existingSerialsForGrade) {
    final val = int.tryParse(serialStr);
    if (val != null && val > maxSerial) {
      maxSerial = val;
    }
  }

  final nextVal = (maxSerial >= baseSerial) ? (maxSerial + 1) : baseSerial;
  return nextVal.toString();
}
```
