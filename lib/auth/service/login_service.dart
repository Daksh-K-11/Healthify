import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthify/core/constant.dart';
import 'package:healthify/core/pages/main_scaffold.dart';
import 'package:healthify/core/utils.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<void> login(
      String phoneNumber, String password, BuildContext context) async {
    print("<><><><><><><><><><><><><><><><><><><><><>>");
    print("$baseUrl/auth/login/");
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "phone_number": phoneNumber,
          "password": password,
        },
      ),
    );
    if (response.statusCode > 250)  {
      showSnackBar(context, 'Login unsuccessful', false);
    }

    final data = jsonDecode(response.body);
    bearerToken = data['token'];
    
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MainScaffold()));
    }
  }
}
