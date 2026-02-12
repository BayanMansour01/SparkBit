import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/values_manager.dart';

/// Screen shown when app is in maintenance mode
class MaintenanceScreen extends StatelessWidget {
  final String? message;

  const MaintenanceScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Maintenance Lottie Animation
              Lottie.asset(
                AppLotties.underMaintenance,
                width: AppSize.s250,
                height: AppSize.s250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSize.s32),

              // Title
              Text(
                'تحت الصيانة',
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s16),

              // Message
              Text(
                message ?? 'نعمل حالياً على تحسين تجربتك. سنعود قريباً!',
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s40),

              // Loading indicator
              const CircularProgressIndicator(), // Simplified for now or import AppLoadingIndicator if available
              // Restoring original AppLoadingIndicator
              // const AppLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
