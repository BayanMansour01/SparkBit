import 'package:sparkbit/features/contact_us/data/models/contact_method_model.dart';

abstract class ContactRepository {
  Future<List<ContactMethodModel>> getContactMethods();
}
