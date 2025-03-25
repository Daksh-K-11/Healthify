String baseUrl = "http://192.168.189.116:8023/api";
late String bearerToken;

Map<String, String> get headersForAuth {
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $bearerToken",
  };
}
