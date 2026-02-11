# 🎯 نظام فحص إعدادات التطبيق - دليل الاستخدام السريع

## ✅ تم الإنجاز

تم إنشاء نظام احترافي كامل لفحص إعدادات التطبيق عند بدء التشغيل مع:

### المميزات
- ✨ **واجهات Lottie متحركة** جميلة وجذابة
- 🔧 **وضع الصيانة** مع رسائل مخصصة
- 📱 **فحص الإصدار** وإجبار التحديث
- 🎨 **تصميم عربي** احترافي
- 🏗️ **Clean Architecture** نظيفة ومنظمة

### ملفات Lottie المستخدمة
- `assets/Lotties/Under Maintenance.json` - واجهة الصيانة
- `assets/Lotties/Update  App.json` - واجهة التحديث

---

## 🚀 كيفية الاختبار الآن

### الخطوة 1: اختبار وضع الصيانة

افتح ملف:
```
lib/core/repositories/app_config_repository.dart
```

علّق السيناريو الافتراضي وفعّل السيناريو 1:

```dart
// السيناريو 1: وضع الصيانة
return const AppConfig(
  isMaintenance: true,
  maintenanceMessage: 'نعمل على تحسينات رائعة! سنعود خلال ساعة.',
  minVersion: '1.0.0',
  latestVersion: '1.0.0',
  forceUpdate: false,
);
```

شغّل التطبيق - سترى واجهة الصيانة مع Lottie متحرك!

### الخطوة 2: اختبار التحديث الإجباري

في نفس الملف، فعّل السيناريو 2:

```dart
// السيناريو 2: تحديث إجباري
return const AppConfig(
  isMaintenance: false,
  minVersion: '999.0.0', // إصدار عالي جداً لإجبار التحديث
  latestVersion: '999.0.0',
  forceUpdate: true,
  updateMessage: 'يتوفر إصدار جديد مع ميزات رائعة! قم بالتحديث الآن.',
  androidUrl: 'https://play.google.com/store/apps/details?id=com.example.yuna',
  iosUrl: 'https://apps.apple.com/app/id0000000000',
);
```

شغّل التطبيق - سترى واجهة التحديث مع الـ Lottie ومقارنة الإصدارات!

---

## 📂 البنية

```
lib/
├── core/
│   ├── models/
│   │   ├── app_config.dart          # النموذج الرئيسي
│   │   ├── app_config.freezed.dart  # Freezed generated
│   │   └── app_config.g.dart        # JSON generated
│   ├── network/
│   │   ├── api/
│   │   │   └── app_config_api.dart  # خدمة API (جاهز للربط)
│   │   └── dio_client.dart          # إعدادات Dio
│   ├── repositories/
│   │   └── app_config_repository.dart  # ⭐ هنا يمكنك التبديل بين السيناريوهات
│   ├── providers/
│   │   └── app_config_provider.dart    # Riverpod Providers
│   └── di/
│       └── service_locator.dart        # Dependency Injection
└── features/
    └── app_config/
        └── presentation/
            ├── screens/
            │   ├── maintenance_screen.dart      # 🎨 واجهة الصيانة
            │   └── update_required_screen.dart  # 🎨 واجهة التحديث
            └── widgets/
                └── app_config_wrapper.dart      # Wrapper الرئيسي
```

---

## 🔗 ربط API حقيقي لاحقاً

عند جاهزية الـ backend:

### 1. حدّث URL الـ API

في `lib/core/network/dio_client.dart`:
```dart
baseUrl: 'https://your-api-url.com/api', // ضع رابط API الخاص بك
```

### 2. فعّل الكود الحقيقي

في `lib/core/repositories/app_config_repository.dart`، علّق التست واستخدم:
```dart
try {
  return await _api.getConfig();
} catch (e) {
  return const AppConfig(
    minVersion: '1.0.0',
    latestVersion: '1.0.0',
    isMaintenance: false,
    forceUpdate: false,
  );
}
```

### 3. شكل الـ JSON المتوقع من الـ Backend

```json
{
  "is_maintenance": false,
  "maintenance_message": "نعمل على تحسينات!",
  "min_version": "1.0.0",
  "latest_version": "1.2.0",
  "force_update": true,
  "update_message": "تحديث مطلوب",
  "android_url": "https://play.google.com/store/apps/...",
  "ios_url": "https://apps.apple.com/app/..."
}
```

---

## 🎨 التخصيص

### تغيير ألوان وتصميم

```dart
// في maintenance_screen.dart و update_required_screen.dart
Lottie.asset(
  'assets/Lotties/Under Maintenance.json',
  width: 300, // غيّر الحجم
  height: 300,
)
```

### تغيير النصوص

```dart
Text(
  'تحت الصيانة', // غيّر العنوان
  style: GoogleFonts.outfit(
    fontSize: AppSizes.font3xl,
  ),
)
```

---

## ⚙️ الإعدادات

### تغيير مدة محاكاة الشبكة

في `app_config_repository.dart`:
```dart
await Future.delayed(const Duration(seconds: 1)); // غيّر من 2 إلى 1
```

---

## 📱 كيف يعمل النظام؟

1. **عند فتح التطبيق**:
   - `main.dart` ينشئ `AppConfigWrapper`
   - يتم فحص الإعدادات من الـ Repository
   
2. **الفحوصات بالترتيب**:
   - ✅ الصيانة أولاً → `MaintenanceScreen`
   - ✅ ثم التحديث → `UpdateRequiredScreen`
   - ✅ إذا نجحت الفحوصات → التطبيق العادي

3. **Fail-Safe**:
   - إذا فشل الـ API، التطبيق يعمل عادي
   - لا يتوقف التطبيق أبداً

---

## 🎬 جرّب الآن!

1. افتح `lib/core/repositories/app_config_repository.dart`
2. علّق السيناريو الافتراضي
3. فعّل السيناريو 1 (الصيانة) أو 2 (التحديث)
4. شغّل التطبيق وشاهد النتيجة!

---

## 💡 نصائح

- استخدم الـ Lottie animations لجعل التجربة أفضل ✨
- اختبر كل السيناريوهات قبل النشر
- تأكد من صحة روابط المتاجر
- استخدم رسائل واضحة للمستخدمين

---

تم الإنجاز بنجاح! 🎉
