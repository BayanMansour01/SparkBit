import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../resources/values_manager.dart';

class DialogUtils {
  static Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withOpacity(0.9),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r24),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(
                AppPadding.p24,
                AppPadding.p32,
                AppPadding.p24,
                AppPadding.p16,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: AppSize.s32,
                    ),
                  ),
                  const SizedBox(height: AppSize.s24),
                  Text(
                    AppStrings.exitApp,
                    style: TextStyle(
                      fontSize: AppSize.s20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  Text(
                    AppStrings.exitAppMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSize.s32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.cancel,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSize.s12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          child: const Text(
                            AppStrings.exit,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}
