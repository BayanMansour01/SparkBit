import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/service_locator.dart';
import '../models/app_constants.dart';
import '../repositories/constants_repository.dart';

final constantsRepositoryProvider = Provider<ConstantsRepository>((ref) {
  return getIt<ConstantsRepository>();
});

final appConstantsProvider = FutureProvider<AppConstants>((ref) async {
  final repository = ref.watch(constantsRepositoryProvider);
  return await repository.getConstants();
});
