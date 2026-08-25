# Quickstart & Verification Guide: Auto-Generated Student Serial Number

## Validation Scenarios

### Scenario 1: Initial Form Open & Default Grade
1. Launch app and navigate to **Students** -> **Add Student**.
2. **Verify**:
   - Grade dropdown defaults to **Prep 1** (`prep_1`).
   - "Not Specified" option is NOT present in the grade dropdown list.
   - The Serial Number field is situated at the **bottom** of the form.
   - The Serial Number field displays `10777` (or `10777 + count`).

### Scenario 2: Dynamic Grade Selection Change
1. In the Add Student form, switch Grade from **Prep 1** to **Prep 2**.
2. **Verify**:
   - The serial number field immediately updates to `20777`.
3. Switch Grade to **Sec 1**.
2. **Verify**:
   - The serial number field immediately updates to `40777`.

### Scenario 3: Saving Student & Sequential Counter Increment
1. Fill required student details for **Prep 1** and save.
2. Re-open **Add Student** form.
3. Select **Prep 1**.
4. **Verify**:
   - The auto-generated serial number field displays `10778`.

---

## Verification Commands

```bash
flutter analyze
flutter test
```
