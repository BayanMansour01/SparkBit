# نظام فحص إعدادات التطبيق (App Config System)

## نظرة عامة

نظام احترافي لفحص إعدادات التطبيق عند بدء التشغيل، يتضمن:
- ✅ فحص الإصدار وإجبار التحديث
- ✅ وضع الصيانة
- ✅ بنية نظيفة مع Riverpod و Clean Architecture
- ✅ واجهات عربية جميلة

## البنية

```
lib/
├── core/
│   ├── models/
│   │   └── app_config.dart          # نموذج البيانات
│   ├── network/
│   │   ├── api/
│   │   │   └── app_config_api.dart  # خدمة API
│   │   └── dio_client.dart          # إعدادات Dio
│   ├── repositories/
│   │   └── app_config_repository.dart  # طبقة Repository
│   ├── providers/
│   │   └── app_config_provider.dart    # Riverpod Providers
│   └── di/
│       └── service_locator.dart        # Dependency Injection
└── features/
    └── app_config/
        └── presentation/
            ├── screens/
            │   ├── maintenance_screen.dart      # واجهة الصيانة
            │   └── update_required_screen.dart  # واجهة التحديث
            └── widgets/
                └── app_config_wrapper.dart      # Wrapper الرئيسي
```

## كيفية الاستخدام

### 1. إعداد Backend API

يجب أن يكون لديك endpoint في الـ backend يرجع JSON بهذا الشكل:

```json
{
  "is_maintenance": false,
  "maintenance_message": "نعمل على تحسينات. سنعود قريباً!",
  "min_version": "1.0.0",
  "latest_version": "1.2.0",
  "force_update": true,
  "update_message": "يرجى تحديث التطبيق للحصول على أحدث الميزات",
  "android_url": "https://play.google.com/store/apps/details?id=com.yourapp",
  "ios_url": "https://apps.apple.com/app/idXXXXXXXXX"
}
```

### 2. تحديث URL الـ API

في ملف `lib/core/network/dio_client.dart`:

```dart
baseUrl: 'https://your-api-url.com/api', // ضع رابط الـ API هنا
```

### 3. كيفية العمل

عند بدء التطبيق:

1. **يقوم `AppConfigWrapper` بفحص الإعدادات من الـ backend**
2. **يتحقق من وضع الصيانة أولاً:**
   - إذا كان `is_maintenance = true`، يعرض `MaintenanceScreen`
3. **يتحقق من الإصدار:**
   - يقارن إصدار التطبيق الحالي مع `min_version`
   - إذا كان الإصدار أقل و `force_update = true`، يعرض `UpdateRequiredScreen`
4. **إذا نجحت كل الفحوصات، يعرض التطبيق العادي**

### 4. سيناريوهات الاستخدام

#### السيناريو 1: تشغيل وضع الصيانة
```json
{
  "is_maintenance": true,
  "maintenance_message": "جاري الصيانة الدورية. سنعود خلال ساعة."
}
```
النتيجة: جميع المستخدمين سيرون شاشة الصيانة

#### السيناريو 2: إجبار التحديث
```json
{
  "is_maintenance": false,
  "min_version": "2.0.0",
  "force_update": true,
  "android_url": "https://play.google.com/...",
  "ios_url": "https://apps.apple.com/..."
}
```
النتيجة: أي مستخدم لديه إصدار أقل من 2.0.0 سيرى شاشة تحديث

#### السيناريو 3: تحديث اختياري
```json
{
  "is_maintenance": false,
  "min_version": "1.0.0",
  "latest_version": "1.5.0",
  "force_update": false
}
```
النتيجة: التطبيق سيعمل بشكل طبيعي (يمكنك إضافة تنبيه اختياري لاحقاً)

## المميزات

### ✅ Clean Architecture
- فصل واضح بين الطبقات (Models, API, Repository, Providers)
- سهولة الصيانة والتطوير

### ✅ Error Handling
- إذا فشل طلب الـ API، يعرض التطبيق بشكل طبيعي (fail-safe)
- لا يتوقف التطبيق إذا كان الـ backend معطل

### ✅ واجهات احترافية
- تصميم عربي جميل
- متناسق مع تصميم التطبيق
- رسائل واضحة للمستخدم

### ✅ مقارنة الإصدارات الذكية
- يقارن الإصدارات بشكل صحيح (مثال: 1.0.0 < 1.0.1 < 1.1.0)

## التخصيص

### تغيير التصميم
يمكنك تعديل ألوان وتصميم الشاشات في:
- `maintenance_screen.dart`
- `update_required_screen.dart`

### إضافة فحوصات إضافية
يمكنك إضافة فحوصات جديدة في `app_config_wrapper.dart`

### مثال: إضافة تنبيه تحديث اختياري:

```dart
// في AppConfigProvider
final optionalUpdateProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  final currentVersion = await ref.watch(currentAppVersionProvider.future);
  
  return _isVersionLower(currentVersion, config.latestVersion);
});
```

## ملاحظات مهمة

1. **اختبر النظام جيداً** قبل نشره للإنتاج
2. **تأكد من صحة روابط المتاجر** (Google Play, App Store)
3. **استخدم إصدارات Semantic Versioning** (X.Y.Z)
4. **اجعل رسائل الصيانة واضحة** للمستخدمين

## اختبار محلي

لاختبار النظام محلياً، يمكنك:

1. **تعديل `AppConfigRepository`** لإرجاع بيانات تجريبية:

```dart
return const AppConfig(
  isMaintenance: true,  // اختبار وضع الصيانة
  minVersion: '999.0.0', // اختبار التحديث الإجباري
  latestVersion: '999.0.0',
  forceUpdate: true,
);
```

2. **أو استخدام mock API** مثل mockapi.io

## الدعم

إذا كان لديك أي استفسار أو مشكلة، تواصل مع فريق ال development.
