import 'dart:io'; // ضروري لمعرفة نوع المنصة
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/app_config/presentation/providers/app_config_provider.dart';

class AppUpdateListener extends ConsumerWidget {
  final Widget child;

  const AppUpdateListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // الاستماع لحالة التحديث الإجباري
    ref.listen(updateRequiredProvider, (previous, next) {
      // استخدام next.value بدلاً من whenData لضمان الاستجابة الصحيحة
      if (next.value == true) {
        _showUpdateDialog(context, ref);
      }
    });

    return child;
  }

  void _showUpdateDialog(BuildContext context, WidgetRef ref) async {
    // جلب البيانات من الـ Provider
    final config = await ref.read(appConfigProvider.future);

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق النافذة لأن التحديث إجباري
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Required'),
        content: Text(
        
          'A new version of the app is available. Please update to continue.',
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                // استخدام updateUrl الذي يختار الرابط الصحيح تلقائياً (iOS أو Android)
                final url = Uri.parse(config.updateUrl);

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Update Now'),
            ),
          ),
        ],
      ),
    );
  }
}
