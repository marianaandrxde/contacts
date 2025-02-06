import 'package:contacts/controllers/contact_controller.dart';
import 'package:contacts/models/contact.dart';
import 'package:flutter/material.dart';
import 'contact_form.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}class _ContactListScreenState extends State<ContactListScreen> {
  final ContactController _contactController = ContactController();
  late Future<List<Contact>> _contacts; 

  @override
  void initState() {
    super.initState();
    _contacts = _contactController.fetchAllContacts(); 
  }

  void _navigateToAddContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactFormScreen()),
    ).then((_) {
      setState(() {
        _contacts = _contactController.fetchAllContacts();
      });
    });
  }

  void _navigateToEditContact(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactFormScreen(contactId: id),
      ),
    ).then((_) {
      setState(() {
        _contacts = _contactController.fetchAllContacts();
      });
    });
  }

  void _deleteContact(int id) async {
    await _contactController.deleteContact(id);
    setState(() {
      _contacts = _contactController.fetchAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de contatos')),
      body: FutureBuilder<List<Contact>>(
        future: _contacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum contato encontrado.'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.nome),
                  subtitle: Text(contact.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToEditContact(contact.id!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteContact(contact.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
