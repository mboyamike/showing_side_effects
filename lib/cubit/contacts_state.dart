part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  ContactsLoaded({required this.contacts});
  final List<String> contacts;
}
