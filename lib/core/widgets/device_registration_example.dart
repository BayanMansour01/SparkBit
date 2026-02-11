import 'package:flutter/material.dart';
import '../resources/values_manager.dart';
import 'app_loading_indicator.dart';
import '../di/service_locator.dart';
import '../services/device_service.dart';

/// مثال توضيحي لكيفية استخدام DeviceService
/// يمكنك استدعاء هذا في main.dart بعد تسجيل الدخول
class DeviceRegistrationGuide {
  /// ✅ السيناريو 1: التسجيل عند بدء التطبيق
  /// يتم استدعاؤه في main() أو بعد تسجيل الدخول مباشرة
  static Future<void> registerOnAppStart(String fcmToken) async {
    final deviceService = getIt<DeviceService>();
    
    try {
      // سيقوم بالمقارنة تلقائياً ويرسل فقط إذا تغيرت المعلومات
      final wasRegistered = await deviceService.registerDeviceIfChanged(fcmToken: fcmToken);
      
      if (wasRegistered) {
        debugPrint('✅ Device registered/updated successfully');
      } else {
        debugPrint('ℹ️ Device info unchanged, skipped API call to save server resources');
      }
    } catch (e) {
      debugPrint('❌ Error registering device: $e');
      // يمكنك إظهار رسالة للمستخدم أو تسجيل الخطأ
    }
  }

  /// ✅ السيناريو 2: التسجيل عند تحديث FCM Token
  /// يتم استدعاؤه عند استلام token جديد من Firebase
  static Future<void> registerOnTokenRefresh(String newFcmToken) async {
    final deviceService = getIt<DeviceService>();
    
    try {
      // حتى لو الـ device info نفسه، إذا الـ token تغير سيرسل
      await deviceService.registerDeviceIfChanged(fcmToken: newFcmToken);
      debugPrint('✅ New FCM token registered');
    } catch (e) {
      debugPrint('❌ Error updating FCM token: $e');
    }
  }

  /// ✅ السيناريو 3: مسح معلومات الجهاز عند تسجيل الخروج
  /// يتم استدعاؤه عند Logout
  static Future<void> clearOnLogout() async {
    final deviceService = getIt<DeviceService>();
    
    try {
      await deviceService.clearDeviceInfo();
      debugPrint('✅ Device info cleared from local storage');
    } catch (e) {
      debugPrint('❌ Error clearing device info: $e');
    }
  }

  /// ✅ السيناريو 4: الحصول على معلومات الجهاز الحالية (للعرض فقط)
  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceService = getIt<DeviceService>();
    
    final deviceType = await deviceService.getDeviceType();
    final deviceInfo = await deviceService.getDeviceInfo();
    
    return {
      'type': deviceType,
      'info': deviceInfo,
    };
  }
}

// ════════════════════════════════════════════════════════════════
// 📍 كيفية الاستخدام في التطبيق الحقيقي
// ════════════════════════════════════════════════════════════════

/// مثال 1️⃣: في main.dart بعد تسجيل الدخول
class MainAppExample {
  Future<void> onAppStart() async {
    // بعد تسجيل الدخول بنجاح وحصولك على FCM token
    final fcmToken = 'your-fcm-token-from-firebase';
    
    // سجل الجهاز (سيقارن تلقائياً ويرسل فقط إذا لزم الأمر)
    await DeviceRegistrationGuide.registerOnAppStart(fcmToken);
  }
}

/// مثال 2️⃣: عند استلام FCM Token جديد
class FirebaseMessagingExample {
  void setupFirebaseMessaging() {
    // عند تحديث Token
    // FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    //   DeviceRegistrationGuide.registerOnTokenRefresh(newToken);
    // });
  }
}

/// مثال 3️⃣: عند تسجيل الخروج
class LogoutExample {
  Future<void> logout() async {
    // منطق تسجيل الخروج...
    
    // امسح معلومات الجهاز المحفوظة
    await DeviceRegistrationGuide.clearOnLogout();
    
    // باقي كود الخروج...
  }
}

/// مثال 4️⃣: عرض معلومات الجهاز في الإعدادات
class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معلومات الجهاز')),
      body: FutureBuilder<Map<String, String>>(
        future: DeviceRegistrationGuide.getDeviceInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }
          
          final deviceInfo = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نوع الجهاز: ${deviceInfo['type']}'),
                const SizedBox(height: AppSize.s8),
                Text('معلومات الجهاز: ${deviceInfo['info']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// 💡 ملاحظات مهمة
// ════════════════════════════════════════════════════════════════
/*
1. ✅ الذكاء التلقائي:
   - DeviceService يقارن تلقائياً device_type, device_info, fcm_token
   - إذا كانت نفس القيم المحفوظة، لن يرسل أي طلب للسيرفر
   - هذا يوفر موارد السيرفر ويقلل الطلبات غير الضرورية

2. ✅ متى يتم الإرسال:
   - عند أول مرة يتم فيها تسجيل الجهاز
   - عند تغيير نوع الجهاز (مثلاً نقل من Android لـ iOS)
   - عند تغيير FCM Token
   - عند تحديث نظام التشغيل (يتغير device_info)

3. ✅ متى لا يتم الإرسال:
   - كل مرة يفتح المستخدم التطبيق إذا لم يتغير شيء
   - إذا الـ token نفسه والجهاز نفسه

4. ✅ أفضل الممارسات:
   - استدعي registerDeviceIfChanged في onAppStart بعد تسجيل الدخول
   - استدعي clearDeviceInfo عند تسجيل الخروج
   - تابع تحديثات FCM token واستدعي registerOnTokenRefresh
*/
