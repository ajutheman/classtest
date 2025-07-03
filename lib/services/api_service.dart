import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://yourapi.com';

  Future<dynamic> post(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> uploadMultipart(String path, Map<String, String> fields, List<http.MultipartFile> files) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$path'));
    request.fields.addAll(fields);
    request.files.addAll(files);

    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(response.body);
  }
}
