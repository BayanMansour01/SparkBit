import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/dialog_utils.dart';

/// Wraps top-level tab screens to override the default back button behavior.
/// This ensures the user gets an exit confirmation dialog instead of navigating
/// to the first tab (GoRouter default behavior) or doing nothing.
class ExitConfirmWrapper extends StatelessWidget {
  final Widget child;

  const ExitConfirmWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Show exit dialog when back button is pressed on a main tab
        final shouldExit = await DialogUtils.showExitDialog(context);
        if (shouldExit && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
