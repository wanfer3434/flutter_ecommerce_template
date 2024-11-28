import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String userMessage) async {
    // Agrega el mensaje del usuario a la lista
    setState(() {
      messages.add({"sender": "user", "text": userMessage});
    });

    // Enviar mensaje al servidor
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/chat'), // Cambia la URL si el backend está en producción
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"message": userMessage}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      String botMessage = responseBody['response'];

      // Agregar la respuesta del bot a la lista
      setState(() {
        messages.add({"sender": "bot", "text": botMessage});
      });
    } else {
      setState(() {
        messages.add({
          "sender": "bot",
          "text": "Hubo un problema al conectar con el servidor. Inténtalo nuevamente."
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatBot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['sender'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['sender'] == 'user'
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['text'] ?? ""),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe tu mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
