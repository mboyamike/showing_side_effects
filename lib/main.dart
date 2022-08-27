import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showing_value_listenable/cubit/contact_permission_cubit.dart';
import 'package:showing_value_listenable/cubit/contacts_cubit.dart';
import 'package:showing_value_listenable/repository/contacts_repository.dart';

void main() {
  final contactsRepository = ContactsRepository();
  runApp(App(contactsRepository: contactsRepository));
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.contactsRepository,
  }) : super(key: key);

  final ContactsRepository contactsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: contactsRepository,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ContactsCubit(
            contactsRepository: context.read<ContactsRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => ContactPermissionCubit(
            contactsRepository: context.read<ContactsRepository>(),
          )..checkPermissionStatus(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactPermissionCubit, ContactPermissionState>(
      listener: (context, state) {
        log('$state');
        if (state is ContactPermissionLoaded) {
          final status = state.status;

          if (status == ContactPermissionStatus.denied) {
            // Warning though, this approach can keep asking as long as someone 
            // is denying. Better to show a button on the UI
            context.read<ContactPermissionCubit>().requestPermission();
          }

          if ([
            ContactPermissionStatus.accepted,
            ContactPermissionStatus.acceptedLimited,
          ].contains(status)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission Accepted')),
            );
            context.read<ContactsCubit>().fetchContacts();
          }
        }
      },
      child: BlocBuilder<ContactPermissionCubit, ContactPermissionState>(
        builder: (context, permissionState) {
          if (permissionState is ContactPermissionLoading) {
            return const LoadingWidget();
          }

          return BlocBuilder<ContactsCubit, ContactsState>(
            builder: (_, state) {
              if (state is ContactsLoaded) {
                final contacts = state.contacts;
                return ListView.separated(
                  itemBuilder: (_, index) => ListTile(
                    title: Text(contacts[index]),
                  ),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: contacts.length,
                );
              }

              return const LoadingWidget();
            },
          );
        },
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
