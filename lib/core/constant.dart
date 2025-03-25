String baseUrl = "http://192.168.189.116:8000/api";
late String bearerToken;

Map<String, String> get headersForAuth {
  // if (bearerToken == null) {
  //   throw Exception('Bearer token is not initialized');
  // }
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $bearerToken",
  };
}
