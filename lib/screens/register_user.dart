import 'package:demo1/screens/nfc_write_screen.dart';
import 'package:demo1/services/api_service.dart';
import 'package:flutter/material.dart';

class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _matricNoController,
                decoration: InputDecoration(labelText: 'Matric. Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Matriculation Number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNoController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  return null; // Phone number is optional
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with registration
                    _registerUser();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser () async {
    // show loading dialog
    _showLoadingDialog();

    // Gather the values entered by the user
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String matricNo = _matricNoController.text;
    String email = _emailController.text;
    String phoneNo = _phoneNoController.text;
    String password = _passwordController.text;

    // Call the ApiService to register the user
    bool success = await _apiService.registerUser(
      firstName: firstName,
      lastName: lastName,
      matricNo: matricNo.isNotEmpty ? matricNo : null,
      email: email,
      phoneNo: phoneNo.isNotEmpty ? phoneNo : null,
      password: password,
    );

    // hide the loading dialog
    Navigator.of(context).pop();

    // print(' $firstName, $lastName, $email');

    // Show a success or failure message
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NfcWriteScreen(matricNo: matricNo),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register user')),
      );
    }

    // print('User registered with data: $firstName, $lastName, $username, $email');
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Registering..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
