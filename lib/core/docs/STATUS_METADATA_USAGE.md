# Status Metadata Usage Guide

## ✅ نعم! تم تطبيق كل شيء بشكل صحيح

هذا الدليل يوضح كيف يتم جلب واستخدام `status` من الـ metadata بدون أي hardcoding.

---

## 📋 **1. البيانات تأتي من API**

### API Response للـ Constants:

```json
{
  "success": true,
  "data": {
    "user_statuses": [
      { "value": "active", "label": "Active" },
      { "value": "inactive", "label": "Inactive" },
      { "value": "suspended", "label": "Suspended" }
    ],
    "user_roles": [...],
    "activity_statuses": [...],
    "payment_statuses": [...]
  }
}
```

### Model التعامل مع الـ metadata:

```dart
// lib/core/models/app_constants.dart
@freezed
abstract class AppConstants with _$AppConstants {
  const factory AppConstants({
    @JsonKey(name: 'user_statuses') required List<ConstantValue> userStatuses,
    @JsonKey(name: 'user_roles') required List<ConstantValue> userRoles,
    @JsonKey(name: 'activity_statuses') required List<ConstantValue> activityStatuses,
    @JsonKey(name: 'payment_statuses') required List<ConstantValue> paymentStatuses,
  }) = _AppConstants;
}

// lib/core/models/constant_value.dart
@freezed
abstract class ConstantValue with _$ConstantValue {
  const factory ConstantValue({
    required String value,  // للإرسال إلى الباك إند
    required String label,  // للعرض في الواجهة
  }) = _ConstantValue;
}
```

---

## 📋 **2. UserProfile يستخدم ConstantValue**

```dart
// lib/core/models/user_profile.dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    required String name,
    required String email,
    String? avatar,
    required String role,
    ConstantValue? status,  // ← هنا! status من نوع ConstantValue
    @JsonKey(name: 'userDevice') UserDevice? userDevice,
    ...
  }) = _UserProfile;
}
```

### API Response للـ Profile:

```json
{
  "id": 8,
  "name": "Bayan Mansour",
  "status": {
    "value": "active",  // ← يتم إرسال value للباك إند
    "label": "Active"   // ← يتم عرض label في الواجهة
  }
}
```

---

## 🎯 **3. كيفية الاستخدام في الواجهة**

### أ) جلب قيم Status من Metadata:

```dart
// في أي Widget
final constants = ref.watch(appConstantsProvider).value;

// جلب جميع خيارات status المتاحة
final statusOptions = constants?.userStatusOptions ?? [];
```

### ب) عرض Status في Dropdown:

```dart
DropdownButton<String>(
  value: userProfile.status?.value,
  items: statusOptions.map((status) {
    return DropdownMenuItem<String>(
      value: status.value,        // ← القيمة الفعلية
      child: Text(status.label),  // ← النص المعروض
    );
  }).toList(),
  onChanged: (newValue) {
    // اختيار قيمة جديدة
  },
)
```

### ج) عرض Status الحالي:

```dart
// عرض label في الواجهة
Text(userProfile.status?.label ?? 'Unknown')

// التحقق من القيمة
if (userProfile.status?.value == 'active') {
  // المستخدم نشط
}
```

---

## 🔄 **4. إرسال Update للباك إند**

```dart
Future<void> updateUserStatus(String newStatusValue) async {
  final body = {
    'status': newStatusValue,  // ← نرسل value فقط
  };
  
  await profileRepository.updateProfile(body);
}

// مثال:
updateUserStatus('active');  // نرسل 'active' وليس 'Active'
```

---

## ✅ **5. التحقق من عدم وجود Hardcoding**

### ❌ **خطأ - Hardcoding:**

```dart
// DON'T DO THIS!
if (userProfile.status?.value == 'active') { ... }

final statusOptions = [
  {'value': 'active', 'label': 'Active'},
  {'value': 'inactive', 'label': 'Inactive'},
];
```

### ✅ **صحيح - استخدام Metadata:**

```dart
// DO THIS!
final constants = ref.watch(appConstantsProvider).value;
final activeStatus = constants?.userStatusOptions.firstWhere(
  (s) => s.value == userProfile.status?.value,
);

// أو ببساطة:
final statusLabel = userProfile.status?.label;
```

---

## 📊 **6. مثال كامل: Edit Profile Screen**

```dart
class EditProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final constants = ref.watch(appConstantsProvider).value;
    
    // جلب خيارات status من metadata
    final statusOptions = constants?.userStatusOptions ?? [];
    
    return Scaffold(
      body: Column(
        children: [
          // عرض Status الحالي
          Text('Current Status: ${profile?.status?.label}'),
          
          // Dropdown لتغيير status
          DropdownButton<String>(
            value: profile?.status?.value,
            items: statusOptions.map((status) {
              return DropdownMenuItem(
                value: status.value,
                child: Text(status.label),
              );
            }).toList(),
            onChanged: (newValue) async {
              if (newValue != null) {
                // إرسال value للباك إند
                await updateStatus(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
  
  Future<void> updateStatus(String statusValue) async {
    // إرسال value فقط للباك إند
    final body = {'status': statusValue};
    // ... call API
  }
}
```

---

## ✅ **الخلاصة:**

1. ✅ **لا يوجد hardcoding** - كل قيم status تأتي من API metadata
2. ✅ **`value`** يُستخدم للتواصل مع الباك إند
3. ✅ **`label`** يُستخدم للعرض في الواجهة
4. ✅ **مرونة كاملة** - يمكن تغيير القيم من الباك إند بدون تغيير الكود
5. ✅ **نوع البيانات** - `ConstantValue` موحد لكل الـ constants

---

## 🎯 **ملاحظات مهمة:**

- يجب جلب `appConstantsProvider` عند بداية التطبيق
- يمكن استخدام نفس الطريقة لـ `userRoles`, `activityStatuses`, `paymentStatuses`
- الـ `value` حساس لحالة الأحرف (case-sensitive)
- دائماً استخدم `label` للعرض و `value` للمنطق والإرسال
