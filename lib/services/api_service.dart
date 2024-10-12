import 'dart:convert';
import 'package:demo1/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<bool> registerUser({
    required String firstName,
    required String lastName,
    String? matricNo,
    required String email,
    String? phoneNo,
    required String password,
  }) async {
    final url = Uri.parse('$localBaseUrl/users/create');

    try {
      // Create the request body
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'matric_no': matricNo,
          'email': email,
          'phone_no': phoneNo,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Registration was successful
        return true;
      } else {
        // Registration failed
        print('Error registering user: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception caught: $e');
      return false;
    }
  }
}