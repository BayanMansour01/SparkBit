import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuna/core/di/service_locator.dart';
import 'package:yuna/features/contact_us/data/models/contact_method_model.dart';
import 'package:yuna/features/contact_us/domain/repositories/contact_repository.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return getIt<ContactRepository>();
});

final contactMethodsProvider =
    FutureProvider.autoDispose<List<ContactMethodModel>>((ref) async {
      final repository = ref.watch(contactRepositoryProvider);
      return repository.getContactMethods();
    });
