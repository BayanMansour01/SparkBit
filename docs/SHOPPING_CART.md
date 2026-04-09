# نظام سلة التسوق (Shopping Cart System)

## نظرة عامة

تم إنشاء نظام سلة تسوق احترافي للكورسات يتضمن:
- إضافة/إزالة الكورسات من السلة
- حساب المجموع الكلي
- إنشاء الطلبات وإرسالها للـ Backend
- واجهات مستخدم احترافية ومتحركة

## البنية المعمارية

### 1. Models (`lib/features/cart/data/models/`)

#### `cart_item_model.dart`
```dart
CartItemModel {
  String id,
  CourseModel course,
  DateTime addedAt,
}
```

#### `order_request_model.dart`
```dart
OrderRequestModel {
  List<int> courseIds, // مطابق للـ API: course_ids[]
}
```

#### `order_response_model.dart`
```dart
OrderResponseModel {
  int id,
  int studentId,
  String totalAmount,
  String status,
  String? paymentMethod,
  String? paymentStatus,
  ...
}
```

### 2. Data Source (`lib/features/cart/data/datasources/`)

#### `cart_remote_datasource.dart`
- استخدام Retrofit لإرسال الطلبات
- Endpoint: `/api/student/orders/create`
- Body: `{ "course_ids": [1, 2, 3] }`

### 3. State Management (`lib/features/cart/presentation/providers/`)

#### `cart_provider.dart`
**Providers:**
- `cartProvider` - الـ Provider الرئيسي لإدارة حالة السلة
- `cartItemCountProvider` - عدد العناصر في السلة
- `cartTotalPriceProvider` - المجموع الكلي
- `isInCartProvider(courseId)` - للتحقق من وجود كورس في السلة

**State:**
```dart
CartState {
  List<CartItemModel> items,
  bool isLoading,
  String? error,
  OrderResponseModel? lastOrder,
  double totalPrice, // computed
  int itemCount, // computed
}
```

**Actions:**
- `addToCart(CourseModel)` - إضافة كورس للسلة
- `removeFromCart(int courseId)` - إزالة كورس من السلة
- `clearCart()` - إفراغ السلة بالكامل
- `createOrder()` - إنشاء طلب وإرساله للـ API
- `clearError()` - مسح رسالة الخطأ
- `clearLastOrder()` - مسح آخر طلب

### 4. UI Screens (`lib/features/cart/presentation/screens/`)

#### `cart_screen.dart`
- عرض قائمة الكورسات في السلة
- زر إفراغ السلة
- ملخص السلة والمجموع
- زر المتابعة للدفع

#### `checkout_screen.dart`
- ملخص الطلب
- اختيار طريقة الدفع
- زر إتمام الطلب
- Dialog تأكيد نجاح الطلب

### 5. UI Widgets (`lib/features/cart/presentation/widgets/`)

#### `cart_item_card.dart`
- عرض معلومات الكورس في السلة
- Swipe to delete functionality
- صورة الكورس، العنوان، المدرب، السعر

#### `cart_summary_card.dart`
- عرض المجموع الكلي
- عدد الكورسات
- زر المتابعة للدفع

#### `empty_cart_widget.dart`
- عرض حالة السلة الفارغة
- Lottie animation
- زر العودة لتصفح الكورسات

#### `order_summary_widget.dart`
- عرض تفاصيل الطلب في شاشة Checkout
- قائمة الكورسات
- المجموع الفرعي والإجمالي

#### `payment_method_selector.dart`
- اختيار طريقة الدفع
- بطاقة ائتمان / محفظة إلكترونية / تحويل بنكي

#### `add_to_cart_button.dart`
- زر إضافة للسلة (للاستخدام في شاشات الكورسات)
- يتغير إلى "عرض السلة" إذا كان الكورس موجود
- إخفاء تلقائي للكورسات المجانية والمشتراة

#### `cart_badge_icon.dart`
- أيقونة السلة مع Badge
- عرض عدد العناصر
- للاستخدام في الـ AppBar

## كيفية الاستخدام

### 1. إضافة أيقونة السلة للـ AppBar

```dart
import 'package:sparkbit/features/cart/presentation/widgets/cart_badge_icon.dart';

AppBar(
  actions: [
    CartBadgeIcon(),
  ],
)
```

### 2. إضافة زر "إضافة للسلة" في شاشة تفاصيل الكورس

```dart
import 'package:sparkbit/features/cart/presentation/widgets/add_to_cart_button.dart';

// Full button version
AddToCartButton(
  course: courseModel,
  showFullButton: true,
)

// Icon button version
AddToCartButton(
  course: courseModel,
  showFullButton: false,
)
```

### 3. فتح شاشة السلة

```dart
import 'package:sparkbit/features/cart/presentation/screens/cart_screen.dart';

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => CartScreen(),
  ),
);
```

### 4. إضافة كورس للسلة برمجياً

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sparkbit/features/cart/presentation/providers/cart_provider.dart';

// In a ConsumerWidget
ref.read(cartProvider.notifier).addToCart(courseModel);
```

### 5. الاستماع لحالة السلة

```dart
// Get cart items count
final itemCount = ref.watch(cartItemCountProvider);

// Get total price
final totalPrice = ref.watch(cartTotalPriceProvider);

// Check if course is in cart
final isInCart = ref.watch(isInCartProvider(courseId));

// Get full cart state
final cartState = ref.watch(cartProvider);
```

## API Integration

### Endpoint
```
POST /api/student/orders/create
```

### Request Body
```json
{
  "course_ids": [1, 2, 3, 4]
}
```

### Response
```json
{
  "success": true,
  "message": "Order created successfully",
  "data": {
    "id": 1,
    "student_id": 123,
    "total_amount": "1500.00",
    "status": "pending",
    "payment_method": null,
    "payment_status": null,
    "created_at": "2026-02-07T09:30:00.000000Z",
    "updated_at": "2026-02-07T09:30:00.000000Z"
  }
}
```

## Features

### ✅ تمت إضافتها

1. **إدارة حالة احترافية** باستخدام Riverpod
2. **واجهات مستخدم حديثة** مع animations
3. **Swipe to delete** للكورسات في السلة
4. **حساب تلقائي** للمجموع الكلي
5. **Validation** للكورسات المجانية والمشتراة
6. **Error handling** شامل
7. **Success animations** عند إتمام الطلب
8. **Badge** على أيقونة السلة

### مميزات إضافية يمكن إضافتها لاحقاً

- حفظ السلة في Local Storage (باستخدام Hive أو SharedPreferences)
- إضافة Coupon codes
- دمج مع Payment Gateways
- إضافة Wishlist منفصلة عن السلة
- تتبع حالة الطلبات

## ملاحظات مهمة

1. **الكورسات المجانية**: لا يمكن إضافتها للسلة
2. **الكورسات المشتراة**: لا يمكن إضافتها للسلة
3. **الكورسات المكررة**: لا يمكن إضافة نفس الكورس مرتين
4. **السلة الفارغة**: لا يمكن إنشاء طلب من سلة فارغة
5. **تنظيف السلة**: يتم إفراغ السلة تلقائياً بعد إنشاء الطلب بنجاح

## Assets المطلوبة

تأكد من إضافة هذه الملفات في مجلد `assets/animations/`:

1. `empty_cart.json` - animation للسلة الفارغة
2. `success.json` - animation لنجاح العملية

يمكنك تحميلها من [LottieFiles](https://lottiefiles.com/)
