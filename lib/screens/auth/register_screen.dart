import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Default role is 'user'
    User newUser = User(username: username, password: password, role: 'user');
    await dbHelper.insertUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}