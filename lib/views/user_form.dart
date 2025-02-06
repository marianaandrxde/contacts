import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final UserController userController = UserController();

  void _registerUser() async {
  final result = await userController.registerUser(
    usernameController.text,
    emailController.text,
    senhaController.text,
  );

  if (result > 0) {
    final users = await userController.fetchAllUsers();
    print("Usuários cadastrados: $users");
  } else {
    print("Falha no cadastro");
  }

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nome de usuário'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
