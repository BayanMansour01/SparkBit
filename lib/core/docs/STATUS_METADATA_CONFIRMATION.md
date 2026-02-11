# ✅ تأكيد: Status مرتبط بالكامل بالـ Metadata

## 📋 **الإجابة: نعم! كل شيء مطبق بشكل صحيح ✅**

---

## **1. كيف يتم جلب Status من API (Metadata)**

### الخطوة 1: API ترسل user_statuses

```json
GET /api/constants

Response:
{
  "success": true,
  "data": {
    "user_statuses": [
      { "value": "active", "label": "نشط / Active" },
      { "value": "inactive", "label": "غير نشط / Inactive" },
      { "value": "suspended", "label": "موقوف / Suspended" }
    ],
    ...
  }
}
```

### الخطوة 2: التطبيق يخزنها في AppConstants

```dart
// lib/core/models/app_constants.dart
@freezed
abstract class AppConstants with _$AppConstants {
  const factory AppConstants({
    @JsonKey(name: 'user_statuses') required List<ConstantValue> userStatuses,
    ...
  }) = _AppConstants;
}
```

### الخطوة 3: Provider يجلب البيانات عند بدء التطبيق

```dart
// lib/core/providers/app_constants_provider.dart
final appConstantsProvider = AsyncNotifierProvider<AppConstantsNotifier, AppConstants?>(() {
  return AppConstantsNotifier();
});

class AppConstantsNotifier extends AsyncNotifier<AppConstants?> {
  @override
  FutureOr<AppConstants?> build() async {
    return _fetchConstants();  // ← يجلب من API
  }
}
```

---

## **2. كيف يأتي Status للمستخدم من Profile API**

```json
GET /api/student/profile

Response:
{
  "id": 8,
  "name": "Bayan Mansour",
  "status": {
    "value": "active",  // ← القيمة للإرسال للباك إند
    "label": "Active"   // ← النص للعرض في الواجهة
  }
}
```

```dart
// lib/core/models/user_profile.dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    ...
    ConstantValue? status,  // ← نفس النوع من metadata!
    ...
  }) = _UserProfile;
}
```

---

## **3. الاستخدام في الواجهة (UI)**

### أ) عرض Status الحالي (label):

```dart
// في أي Widget
Widget build(BuildContext context, WidgetRef ref) {
  final profile = ref.watch(profileProvider).value;
  
  return Text(
    profile?.status?.label ?? 'غير معروف',  // ← عرض label
    style: TextStyle(fontSize: 16),
  );
}
```

**النتيجة:** يظهر "Active" أو "نشط" حسب ما يأتي من الباك إند

---

### ب) عرض جميع الخيارات في Dropdown:

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final profile = ref.watch(profileProvider).value;
  final constants = ref.watch(appConstantsProvider).value;
  
  // جلب جميع خيارات status من metadata
  final statusOptions = constants?.userStatusOptions ?? [];
  
  return DropdownButton<String>(
    value: profile?.status?.value,  // ← القيمة الحالية
    items: statusOptions.map((status) {
      return DropdownMenuItem<String>(
        value: status.value,         // ← القيمة (active, inactive, etc.)
        child: Text(status.label),   // ← النص المعروض (Active, Inactive, etc.)
      );
    }).toList(),
    onChanged: (newValue) {
      // تحديث status
      _updateStatus(newValue!);
    },
  );
}
```

**الفائدة:**
- ✅ لا hardcoding - كل الخيارات من API
- ✅ إذا أضاف الباك إند status جديد، يظهر تلقائياً
- ✅ إذا غيّر الباك إند label، يتغير في التطبيق

---

## **4. إرسال Update للباك إند (value)**

```dart
Future<void> _updateStatus(String statusValue) async {
  // نرسل value فقط - وليس label!
  final body = {
    'status': statusValue,  // ← "active" وليس "Active"
  };
  
  final result = await profileRepository.updateProfile(body);
  
  result.fold(
    (error) => showError(error.message),
    (success) => showSuccess('تم التحديث بنجاح'),
  );
}
```

---

## **5. مثال كامل: صفحة تعديل Profile**

```dart
class EditProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  String? selectedStatusValue;
  
  @override
  Widget build(BuildContext context) {
    // 1. جلب profile الحالي
    final profileAsync = ref.watch(profileProvider);
    
    // 2. جلب constants (metadata)
    final constantsAsync = ref.watch(appConstantsProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('تعديل الملف الشخصي')),
      body: constantsAsync.when(
        data: (constants) {
          // 3. جلب خيارات status من metadata
          final statusOptions = constants?.userStatusOptions ?? [];
          
          return profileAsync.when(
            data: (profile) {
              // 4. تعيين القيمة الأولية
              selectedStatusValue ??= profile?.status?.value;
              
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // عرض Status الحالي
                  Text(
                    'الحالة الحالية: ${profile?.status?.label ?? "غير معروف"}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Dropdown لاختيار status جديد
                  DropdownButtonFormField<String>(
                    value: selectedStatusValue,
                    decoration: InputDecoration(
                      labelText: 'حالة الحساب',
                      border: OutlineInputBorder(),
                    ),
                    items: statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status.value,    // ← value للإرسال
                        child: Row(
                          children: [
                            Text(status.label),  // ← label للعرض
                            SizedBox(width: 8),
                            // اختياري: عرض value بين قوسين
                            Text(
                              '(${status.value})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStatusValue = newValue;
                      });
                    },
                  ),
                  
                  SizedBox(height: 20),
                  
                  // زر الحفظ
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedStatusValue != null) {
                        await _updateStatus(selectedStatusValue!);
                      }
                    },
                    child: Text('حفظ التغييرات'),
                  ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ في تحميل الإعدادات: $e')),
      ),
    );
  }
  
  Future<void> _updateStatus(String statusValue) async {
    // إرسال value للباك إند
    final body = {'status': statusValue};
    
    final repository = ref.read(profileRepositoryProvider);
    final result = await repository.updateProfile(body);
    
    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التحديث: ${error.message}')),
        );
      },
      (updatedProfile) {
        // تحديث الـ provider
        ref.invalidate(profileProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم التحديث بنجاح')),
        );
      },
    );
  }
}
```

---

## **6. التحقق من عدم وجود Hardcoding**

### ❌ خطأ (Hardcoded):

```dart
// DON'T DO THIS!
final statuses = [
  {'value': 'active', 'label': 'Active'},
  {'value': 'inactive', 'label': 'Inactive'},
];

if (user.status == 'active') { ... }
```

### ✅ صحيح (من Metadata):

```dart
// DO THIS!
final constants = ref.watch(appConstantsProvider).value;
final statuses = constants?.userStatusOptions ?? [];

final activeStatus = statuses.firstWhere(
  (s) => s.value == user.status?.value,
  orElse: () => ConstantValue(value: 'unknown', label: 'Unknown'),
);
```

---

## **7. الخلاصة النهائية**

| **السؤال** | **الإجابة** |
|------------|------------|
| هل status تأتي من API Constants (metadata)? | ✅ **نعم** - من `/api/constants` |
| هل يوجد hardcoding لقيم enum؟ | ❌ **لا** - كل القيم من API |
| هل label يُستخدم للعرض؟ | ✅ **نعم** - `status.label` |
| هل value يُستخدم للإرسال للباك إند؟ | ✅ **نعم** - `status.value` |
| هل يمكن تغيير القيم من الباك إند بدون تغيير الكود؟ | ✅ **نعم** - تماماً! |

---

## **8. الملفات المهمة**

```
lib/
├── core/
│   ├── models/
│   │   ├── app_constants.dart        ← يحتوي userStatuses
│   │   ├── constant_value.dart       ← value & label
│   │   └── user_profile.dart         ← status: ConstantValue?
│   └── providers/
│       └── app_constants_provider.dart  ← يجلب من API
│
└── features/
    └── profile/
        ├── data/
        │   └── repositories/
        │       └── profile_repository_impl.dart  ← updateProfile()
        └── presentation/
            └── screens/
                └── edit_profile_screen.dart  ← استخدام status
```

---

**✅ كل شيء مطبق بشكل صحيح! لا يوجد أي hardcoding، وكل القيم ديناميكية من API!** 🎉
