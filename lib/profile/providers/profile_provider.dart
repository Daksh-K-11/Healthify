import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/core/constant.dart';
import 'package:http/http.dart' as http;

// final profileProvider = FutureProvider((ref) async {
//   final response = await http.get(
//     Uri.parse("$baseUrl/auth/update-static/"),
//     headers: headersForAuth,
//   );
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to load profile');
//   }
// });

final profileProvider = FutureProvider((ref) async {
  print("<><><><><><><><><><><><><><><><><><><><><><");
  print(headersForAuth.toString());
  final response = await http.get(
    Uri.parse("$baseUrl/auth/update-static/"),
    headers: headersForAuth,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load profile');
  }
});
