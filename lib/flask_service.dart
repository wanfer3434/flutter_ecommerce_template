import 'dart:convert';
import 'package:http/http.dart' as http;

class FlaskService {
  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('http://<tu-servidor>:<puerto>/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? 'Error: sin respuesta del bot';
    } else {
      return 'Error: ${response.statusCode}';
    }
  }
}
