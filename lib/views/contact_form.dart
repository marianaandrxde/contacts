import 'package:contacts/controllers/contact_controller.dart';
import 'package:contacts/models/contact.dart';
import 'package:flutter/material.dart';

class ContactFormScreen extends StatefulWidget {
  final int? contactId;
  final VoidCallback? onFormSubmit;

  const ContactFormScreen({super.key, this.contactId, this.onFormSubmit});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ContactController _contactController = ContactController();

  @override
  void initState() {
    super.initState();
    if (widget.contactId != null) {
      _loadContact();
    }
  }

  Future<void> _loadContact() async {
    final contact = await _contactController.fetchContactById(widget.contactId!);
    if (contact != null) {
      _nomeController.text = contact.nome;
      _latitudeController.text = contact.latitude.toString();
      _longitudeController.text = contact.longitude.toString();
      _emailController.text = contact.email;
    }
  }

  Future<void> _saveContact() async {
    final nome = _nomeController.text.trim();
    final latitude = double.tryParse(_latitudeController.text.trim()) ?? 0.0;
    final longitude = double.tryParse(_longitudeController.text.trim()) ?? 0.0;
    final email = _emailController.text.trim();

    final contact = Contact(
      id: widget.contactId,
      nome: nome,
      latitude: latitude,
      longitude: longitude,
      email: email,
    );

    if (widget.contactId == null) {
      await _contactController.addContact(contact);
    } else {
      await _contactController.updateContact(contact);
    }

    widget.onFormSubmit?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _latitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContact,
              child: Text(widget.contactId == null ? 'Adicionar contato' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
