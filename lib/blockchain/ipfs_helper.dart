import 'package:http/http.dart' as http;
import 'dart:convert';

class IPFSHelper {
  static Future<String> uploadToIPFS(String encryptedData) async {
    var response = await http.post(
      Uri.parse("https://api.pinata.cloud/pinning/pinJSONToIPFS"),
      headers: {
        "pinata_api_key": "54f9e609b47f36256738",
        "pinata_secret_api_key": "e2afab725eab338c532ea052b4e04ce7a099e618f18104bb568149ad8820fa15",
        "Content-Type": "application/json"
      },
      body: jsonEncode({"data": encryptedData}),
    );
    return jsonDecode(response.body)["IpfsHash"];
  }
}