import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../screens/body.dart';
import 'package:http/http.dart' as http;

class InputGatewayIP extends StatefulWidget {
  const InputGatewayIP({super.key});

  @override
  State<InputGatewayIP> createState() => _InputGatewayIPState();
}

class _InputGatewayIPState extends State<InputGatewayIP> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  bool flag = false;
  void getStatusServer() async {
    var state = await checkServer();

    setState(() {
      flag = state;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    flag
        ? await prefs.setString(
            'hostUrl', '${ipController.text}:${portController.text}')
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                title: const Text('Notification'),
                content:
                    const Text('Can\'t connect to server\nPlease try again'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
  }

  Future<bool> checkServer() async {
    String url = "http://${Gateway.host}:${Gateway.portHttp}/";
    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode < 400) {
        // print(res.body);
        return true;
      } else {
        return false;
        // throw Exception("Server not running");
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String hostUrl = prefs.getString('hostUrl') ?? ''; // print('checked');
    if (hostUrl != '') {
      Gateway.host = hostUrl.split(':')[0];
      Gateway.portHttp = hostUrl.split(':')[1];
      var stateConnect = await checkServer();
      if (stateConnect) {
        Get.off(() => const ScreenMain());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(kBlueColor, kGreenColor),
      appBar: AppBar(actions: const []),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: ipController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Gateway IP:',
                  hintText: '192.168.1.77',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: portController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Gateway Port:',
                  hintText: '8080',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () async {
                    Gateway.host = ipController.text;
                    Gateway.portHttp = portController.text;

                    // var flag = await checkServer();
                    getStatusServer();
                    // print(flag);

                    checkLoginStatus();
                    // print(Gateway.host);
                  },
                  icon: const Icon(Icons.connected_tv_sharp),
                  label: const Text('Connect')),
            ],
          ),
        ),
      ),
    );
  }
}
