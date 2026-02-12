import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/app_config/presentation/providers/app_config_provider.dart';

class AppUpdateListener extends ConsumerWidget {
  final Widget child;

  const AppUpdateListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for update requirement
    ref.listen(updateRequiredProvider, (previous, next) {
      next.whenData((updateRequired) {
        if (updateRequired) {
          _showUpdateDialog(context, ref);
        }
      });
    });

    return child;
  }

  void _showUpdateDialog(BuildContext context, WidgetRef ref) async {
    final config = await ref.read(appConfigProvider.future);

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Update Required'),
        content: Text(
          config.updateMessage ??
              'A new version of the app is available. Please update to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final url = Uri.parse(config.androidUrl ?? '');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}
