import 'package:showing_value_listenable/cubit/contact_permission_cubit.dart';

class ContactsRepository {
  ContactPermissionStatus _status = ContactPermissionStatus.denied;

  Future<ContactPermissionStatus> requestPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _status = ContactPermissionStatus.accepted;
    return _status;
  }

  Future<ContactPermissionStatus> getCurrentStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _status;
  }

  Future<List<String>> getContacts() async {
    final contacts = <String>[
      for (int i = 0; i < 243; i++) '07${i.toString().padLeft(8, '0')}'
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    return contacts;
  }
}
