import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuna/core/di/service_locator.dart';
import 'package:yuna/core/models/app_constants.dart';
import 'package:yuna/core/models/constant_value.dart';
import 'package:yuna/core/repositories/app_constants_repository.dart';

final appConstantsProvider =
    AsyncNotifierProvider<AppConstantsNotifier, AppConstants?>(() {
      return AppConstantsNotifier();
    });

class AppConstantsNotifier extends AsyncNotifier<AppConstants?> {
  @override
  FutureOr<AppConstants?> build() async {
    return _fetchConstants();
  }

  Future<AppConstants?> _fetchConstants() async {
    try {
      final repository = getIt<AppConstantsRepository>();
      final result = await repository.getAppConstants();

      return result.fold((failure) {
        // Log error or handle gracefully
        print('Error fetching constants: ${failure.message}');
        return null;
      }, (data) => data);
    } catch (e) {
      print('Exception fetching constants: $e');
      return null;
    }
  }

  // Reload action
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchConstants());
  }
}

// Helper extensions for easier access from the UI
extension AppConstantsHelper on AppConstants {
  List<ConstantValue> get userStatusOptions => userStatuses;
  List<ConstantValue> get paymentStatusOptions => paymentStatuses;
  List<ConstantValue> get userRoleOptions => userRoles;
  List<ConstantValue> get activityStatusOptions => activityStatuses;
}
