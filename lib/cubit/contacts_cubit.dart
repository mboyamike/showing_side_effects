import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:showing_value_listenable/repository/contacts_repository.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({required this.contactsRepository})
      : super(
          ContactsLoaded(contacts: const []),
        );

  final ContactsRepository contactsRepository;

  Future<void> fetchContacts() async {
    emit(ContactsLoading());
    final contacts = await contactsRepository.getContacts();
    emit(ContactsLoaded(contacts: contacts));
  }
}
