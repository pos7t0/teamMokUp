import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Opinion extends StatefulWidget {
  const Opinion({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  State<Opinion> createState() => _OpinionState();
}

class _OpinionState extends State<Opinion> {
  Map<String, dynamic> feedbackData = {};
  TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFeedbackQuestions();
  }

  Future<void> _loadFeedbackQuestions() async {
    final String response = await rootBundle.loadString('assets/data/validacion.json');
    final data = await json.decode(response);
    setState(() {
      feedbackData = data;
    });
  }

  Future<void> _sendFeedback() async {
    final String feedback = feedbackData.entries.map((entry) {
      final category = entry.key;
      final questions = entry.value as List<dynamic>;
      final questionsText = questions.map((question) {
        return '''
${question['titulo']}
Respuesta: ${question['valor']} estrellas
''';
      }).join('\n');
      return 'Categoria: $category\n$questionsText';
    }).join('\n');

    final Email email = Email(
      body: 'ID Usuario: ${userIdController.text}\n\n$feedback',
      subject: 'Retroalimentación de la Aplicación',
      recipients: ['rodrigo.osvaldo.2003@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Retroalimentación enviada")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'Ingrese su identificación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ...feedbackData.entries.map((entry) {
              final category = entry.key;
              final questions = entry.value as List<dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...questions.map((question) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['titulo'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    question['min'],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    question['max'],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: question['valor'].toDouble(),
                              min: 0,
                              max: 5,
                              divisions: 5,
                              label: question['valor'].toString(),
                              onChanged: (newValue) {
                                setState(() {
                                  question['valor'] = newValue.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _sendFeedback,
                child: const Text('Enviar Retroalimentación'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}