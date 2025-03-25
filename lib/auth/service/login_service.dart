import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthify/core/constant.dart';
import 'package:healthify/core/pages/main_scaffold.dart';
import 'package:healthify/core/utils.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<String?> login(
      String phoneNumber, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: jsonEncode(
        {
          "phone_number": phoneNumber,
          "password": password,
        },
      ),
    );

    if (response.statusCode != 201) {
      showSnackBar(context, 'Login unsuccussful', false);
      return null;
    }

    final data = jsonDecode(response.body);
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MainScaffold()));
    return data['token'];
  }
}
