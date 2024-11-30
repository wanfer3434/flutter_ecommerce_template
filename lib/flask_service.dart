import 'dart:convert';
import 'package:http/http.dart' as http;

class FlaskService {
  static const String _baseUrl = 'http://127.0.0.1:5000/responder';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'] ?? 'Sin respuesta';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al conectar con Flask: $e';
    }
  }
}
