import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../repository/contacts_repository.dart';

part 'contact_permission_state.dart';

class ContactPermissionCubit extends Cubit<ContactPermissionState> {
  ContactPermissionCubit({
    required this.contactsRepository,
  }) : super(ContactPermissionInitial());

  final ContactsRepository contactsRepository;

  Future<void> checkPermissionStatus() async {
    emit(ContactPermissionLoading());
    final status = await contactsRepository.getCurrentStatus();
    
    emit(ContactPermissionLoaded(status: status));
  }

  Future<void> requestPermission() async {
    emit(ContactPermissionLoading());
    final status = await contactsRepository.requestPermission();
    emit(ContactPermissionLoaded(status: status));
  }
}
