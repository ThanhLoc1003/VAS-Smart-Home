import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../constants.dart';
import 'camera_page.dart';

class ValidateStreamPage extends StatefulWidget {
  const ValidateStreamPage({super.key});

  @override
  State<ValidateStreamPage> createState() => _ValidateStreamPageState();
}

class _ValidateStreamPageState extends State<ValidateStreamPage> {
  final TextEditingController _wanIPController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  String _validationResult = '';

  Future<void> _validateStream() async {
    String streamLink =
        "rtsp://admin:${_passwordController.text}@${_wanIPController.text}:${_portController.text}/${_pathController.text}";

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${ServerAI.host}:${ServerAI.port}/validate_stream'),
      );

      request.fields['stream_link'] = streamLink;

      var response = await request.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final result = json.decode(data);

        if (result['status'] == 'ok') {
          Get.off(() => const CameraAiPage());
        } else {
          setState(() {
            _validationResult = result['message'];
          });
        }
      } else {
        setState(() {
          _validationResult = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _validationResult = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Stream'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _wanIPController,
              decoration: const InputDecoration(
                hintText: "89.207.132.170",
                labelText: 'WAN IP:',
              ),
            ),
            TextField(
              controller: _portController,
              decoration:
                  const InputDecoration(labelText: 'Port:', hintText: "554"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password:',
              ),
            ),
            TextField(
              controller: _pathController,
              decoration: const InputDecoration(
                hintText: "H.264",
                labelText: 'Path:',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _validateStream();
              },
              child: const Text('Validate'),
            ),
            const SizedBox(height: 16),
            Text(
              _validationResult,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
