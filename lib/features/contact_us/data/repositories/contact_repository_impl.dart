import 'package:sparkbit/core/network/api/student_api.dart';
import 'package:sparkbit/features/contact_us/data/models/contact_method_model.dart';
import 'package:sparkbit/features/contact_us/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final StudentApi _api;

  ContactRepositoryImpl(this._api);

  @override
  Future<List<ContactMethodModel>> getContactMethods() {
    return _api.getContactMethods();
  }
}
