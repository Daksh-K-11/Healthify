String baseUrl = "http://192.168.189.163:8023/api";
late String bearerToken;

Map<String, String> get headersForAuth {
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $bearerToken",
  };
}
