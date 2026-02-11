import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'package:yuna/core/widgets/app_button.dart';
import '../errors/failure.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              SizedBox(
                height: AppSize.s200,
                width: AppSize.s200,
                child: Lottie.asset(
                  _getLottiePath(),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: AppSize.s60,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          "Missing Lottie Asset",
                          style: TextStyle(
                            fontSize: AppSize.s10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s24),

              // Error Title
              Text(
                _getErrorTitle(),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSize.s8),

              // Error Message
              Text(
                _getErrorMessage(),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: AppSize.s32),

              // Retry Button
              if (onRetry != null)
                AppButton(
                  text: 'Try Again',
                  onPressed: onRetry,
                  icon: Icons.refresh_rounded,
                  width: AppSize.s200,
                  height: 54,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLottiePath() {
    if (error is NetworkFailure) {
      return AppLotties.noInternet;
    } else if (error is ServerFailure) {
      return AppLotties.serverError;
    } else {
      return AppLotties.error404;
    }
  }

  String _getErrorTitle() {
    if (error is NetworkFailure) return 'No Internet Connection';
    if (error is ServerFailure) return 'Service Unavailable';
    return 'Unexpected Error';
  }

  String _getErrorMessage() {
    if (error is NetworkFailure) {
      return 'Please check your internet connection and try again.';
    }
    if (error is ServerFailure) {
      return 'We are having trouble connecting to our servers. Please try again later.';
    }
    // Return a generic message for other errors to avoid showing user ugly stack traces
    return 'Something went wrong. Please try again.';
  }
}
