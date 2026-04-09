# دليل البدء السريع - نظام سلة التسوق

## ✅ تم إنشاء الملفات التالية

### Models
- ✅ `lib/features/cart/data/models/cart_item_model.dart`
- ✅ `lib/features/cart/data/models/order_request_model.dart`
- ✅ `lib/features/cart/data/models/order_response_model.dart`

### Data Source
- ✅ `lib/features/cart/data/datasources/cart_remote_datasource.dart`

### Providers
- ✅ `lib/features/cart/presentation/providers/cart_provider.dart`

### Screens
- ✅ `lib/features/cart/presentation/screens/cart_screen.dart`
- ✅ `lib/features/cart/presentation/screens/checkout_screen.dart`

### Widgets
- ✅ `lib/features/cart/presentation/widgets/cart_item_card.dart`
- ✅ `lib/features/cart/presentation/widgets/cart_summary_card.dart`
- ✅ `lib/features/cart/presentation/widgets/empty_cart_widget.dart`
- ✅ `lib/features/cart/presentation/widgets/order_summary_widget.dart`
- ✅ `lib/features/cart/presentation/widgets/payment_method_selector.dart`
- ✅ `lib/features/cart/presentation/widgets/add_to_cart_button.dart`
- ✅ `lib/features/cart/presentation/widgets/cart_badge_icon.dart`

### API
- ✅ تم إضافة endpoint: `/api/student/orders/create`

## 🚀 الخطوات التالية

### 1. إضافة أيقونة السلة في الـ AppBar

في أي شاشة تريد إضافة أيقونة السلة (مثل الصفحة الرئيسية):

```dart
import 'package:sparkbit/features/cart/presentation/widgets/cart_badge_icon.dart';

AppBar(
  title: Text('الكورسات'),
  actions: [
    CartBadgeIcon(), // أيقونة السلة مع عداد العناصر
  ],
)
```

### 2. إضافة زر "إضافة للسلة" في شاشة تفاصيل الكورس

في `course_details_screen.dart` أو أي مكان تعرض فيه تفاصيل الكورس:

```dart
import 'package:sparkbit/features/cart/presentation/widgets/add_to_cart_button.dart';

// في body الشاشة
AddToCartButton(
  course: courseModel,
  showFullButton: true, // زر كامل
)

// أو للإصدار الأيقونة فقط
AddToCartButton(
  course: courseModel,
  showFullButton: false, // أيقونة فقط
)
```

### 3. تحميل ملفات Lottie Animations

قم بتنزيل الملفات التالية من [LottieFiles](https://lottiefiles.com/):

1. **Empty Cart Animation**
   - ابحث عن "empty shopping cart"
   - احفظ باسم: `assets/Lotties/empty_cart.json`

2. **Success Animation**
   - ابحث عن "success checkmark"
   - احفظ باسم: `assets/Lotties/success.json`

### 4. إعادة تشغيل build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. تشغيل التطبيق

```bash
flutter run
```

## 📱 كيفية الاستخدام

1. **تصفح الكورسات**: اذهب لشاشة الكورسات
2. **إضافة للسلة**: اضغط على زر "إضافة للسلة" بجانب أي كورس
3. **عرض السلة**: اضغط على أيقونة السلة في الـ AppBar
4. **إتمام الطلب**: اضغط على "المتابعة للدفع"
5. **اختر طريقة الدفع**: اختر من بين الخيارات المتاحة
6. **إرسال الطلب**: اضغط على "إتمام الطلب"

## 🔧 API Integration

النظام يرسل الطلب إلى:

```
POST /api/student/orders/create
```

مع body:

```json
{
  "course_ids": [1, 2, 3]
}
```

تأكد من أن الـ Backend جاهز لاستقبال هذا الطلب.

## 📝 ملاحظات مهمة

- الكورسات المجانية لا تظهر عليها زر "إضافة للسلة"
- الكورسات المشتراة لا تظهر عليها زر "إضافة للسلة"
- لا يمكن إضافة نفس الكورس مرتين للسلة
- السلة يتم إفراغها تلقائياً بعد إتمام الطلب بنجاح

## 🎨 التخصيص

يمكنك تخصيص:
- ألوان الأزرار من خلال theme الخاص بالتطبيق
- طرق الدفع في `payment_method_selector.dart`
- حساب السعر الإجمالي في `CartState.totalPrice`

للمزيد من التفاصيل، راجع: `docs/SHOPPING_CART.md`
