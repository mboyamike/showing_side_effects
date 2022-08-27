part of 'contact_permission_cubit.dart';

enum ContactPermissionStatus {
  accepted,
  acceptedLimited,
  denied,
  permanentlyDenied,
}

@immutable
abstract class ContactPermissionState {}

class ContactPermissionInitial extends ContactPermissionState {}

class ContactPermissionLoading extends ContactPermissionState {}

class ContactPermissionLoaded extends ContactPermissionState {
  ContactPermissionLoaded({required this.status});
  final ContactPermissionStatus status;
}
