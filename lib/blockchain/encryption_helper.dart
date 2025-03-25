import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  
  static final key = encrypt.Key.fromUtf8("9vLz!aQ2@xYk#P3mBnS5^DfGhJpZ8dLq");
  static final iv = encrypt.IV.fromLength(16); 

  
  static String encryptFile(Uint8List fileBytes) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
    return base64.encode(encrypted.bytes);
  }

  
  static Uint8List decryptFile(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(base64.decode(encryptedData)), iv: iv);
    return Uint8List.fromList(decrypted);
  }
}