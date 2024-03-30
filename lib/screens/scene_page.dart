import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../define_class/Aircon/aircon.dart';
import '../define_class/Lock/lock.dart';
import '../define_class/Socket/socketC.dart';
import '../define_class/Switch/switchC.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Scenario {
  String name;
  IconData? iconData; // Thêm dấu ? để cho phép giá trị null
  List<bool> conditions;

  Scenario(this.name, this.iconData, this.conditions);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': iconData
          ?.codePoint, // Sử dụng iconData?.codePoint để tránh lỗi nếu iconData là null
      'conditions': conditions,
    };
  }

  // Define a constant IconData variable with desired properties
  static const IconData myIconData =
      IconData(0xe851, fontFamily: 'MaterialIcons');

// Modify the factory method to use the constant IconData variable
  factory Scenario.fromMap(Map<String, dynamic> map) {
    return Scenario(
      map['name'],
      map['iconCodePoint'] != null
          ? myIconData // Use the constant IconData variable
          : null,
      List<bool>.from(map['conditions']),
    );
  }
  // factory Scenario.fromMap(Map<String, dynamic> map) {
  //   return Scenario(
  //     map['name'],
  //     map['iconCodePoint'] != null
  //         ? IconData(map['iconCodePoint'], fontFamily: 'MaterialIcons')
  //         : null, // Kiểm tra giá trị trước khi sử dụng IconData
  //     List<bool>.from(map['conditions']),
  //   );
  // }
}

class ScenarioManager {
  static const String scenariosKey = 'scenarios';

  static Future<void> saveScenarios(List<Scenario> scenarios) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedScenarios =
        scenarios.map((scenario) => scenario.toMap()).toList();
    final encodedString = json.encode(encodedScenarios);
    await prefs.setString(scenariosKey, encodedString);
  }

  static Future<List<Scenario>> loadScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedString = prefs.getString(scenariosKey);

    if (encodedString != null) {
      final List<dynamic> decodedScenarios = json.decode(encodedString);
      return decodedScenarios
          .map((decodedScenario) => Scenario.fromMap(decodedScenario))
          .toList();
    } else {
      return [];
    }
  }
}

class ScenarioPage extends StatefulWidget {
  const ScenarioPage({super.key});

  @override
  State<ScenarioPage> createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  late WebSocketChannel channel;
  bool isLoaded = false;
  int numDevice =
      switchs.length + sockets.length + locks.length + aircons.length;
  @override
  void initState() {
    // channel[widget.]
    channel = WebSocketChannel.connect(
        Uri.parse("ws://${Gateway.host}:${Gateway().portWebsocket}"));
    loadScenarios();
    super.initState();
  }

  Future<void> _chooseScene(int index) async {
    setState(() {});
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Confirm Scenario'),
          // content: Text('Do you really want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (scenerios[index].conditions[0]) {
                  switchs[0].status.button1 = true;
                  switchs[0].status.button2 = true;
                } else {
                  switchs[0].status.button1 = false;
                  switchs[0].status.button2 = false;
                }
                if (scenerios[index].conditions[1]) {
                  sockets[0].status.button1 = true;
                  sockets[0].status.button2 = true;
                } else {
                  sockets[0].status.button1 = false;
                  sockets[0].status.button2 = false;
                }
                if (scenerios[index].conditions[2]) {
                  locks[0].status.button = true;
                } else {
                  locks[0].status.button = false;
                }
                if (scenerios[index].conditions[3]) {
                  aircons[0].status.on = true;
                } else {
                  aircons[0].status.on = false;
                }

                sendData(json.encode(SwitchC(switchs[0].id, switchs[0].name,
                        switchs[0].status, switchs[0].typeDevice)
                    .toJson()));
                sendData(json.encode(SocketC(sockets[0].id, sockets[0].name,
                        sockets[0].status, sockets[0].typeDevice)
                    .toJson()));
                sendData(json.encode(Aircon(aircons[0].id, aircons[0].name,
                        aircons[0].typeDevice, aircons[0].status)
                    .toJson()));
                sendData(json.encode(Lock(locks[0].status, locks[0].id,
                    locks[0].name, locks[0].typeDevice)));
                // if (index == 0) {

                // }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Scenario> scenerios = [
    // Scenario("I'm home", const Icon(Icons.home, color: Colors.black),
    //     [true, true, true, true]),
    // // Scenerio("I'm away", const Icon(Icons.outbond)),
    // Scenario("Go out", const Icon(Icons.outbond, color: Colors.black),
    //     [false, false, false, false]),
    // Scenario(
    //     "Good night",
    //     const Icon(Icons.nightlight_round, color: Colors.black),
    //     [false, false, false, true]),
  ];
  Future<void> loadScenarios() async {
    List<Scenario> loadedScenarios = await ScenarioManager.loadScenarios();
    if (loadedScenarios.isEmpty) {
      // Thêm 3 kịch bản mặc định nếu danh sách là trống
      loadedScenarios.add(
        Scenario("I'm home", Icons.home,
            List<bool>.filled(numDevice, true, growable: true)),

        //[true, true, true, true]),
      );
      loadedScenarios.add(
        Scenario("Go out", Icons.outbond,
            List<bool>.filled(numDevice, false, growable: true)),
      );
      loadedScenarios.add(
        Scenario(
            "Good night", Icons.nightlight_round, [false, false, false, true]),
      );
    }
    setState(() {
      scenerios = loadedScenarios;
      isLoaded = true;
    });
  }

  Future<void> saveScenarios() async {
    await ScenarioManager.saveScenarios(scenerios);
  }

  Future<void> _showCustomScenarioDialog() async {
    TextEditingController scenarioNameController = TextEditingController();

    // Add more controllers for other scenario details if needed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var state = List<bool>.filled(numDevice, false, growable: true);
        return AlertDialog(
          // backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Add Custom Scenario'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: scenarioNameController,
                    onTapOutside: (event) =>
                        FocusManager().primaryFocus?.unfocus(),
                    decoration:
                        const InputDecoration(labelText: 'Scenario Name'),
                  ),
                  SwitchListTile.adaptive(
                      value: state[0],
                      onChanged: ((value) {
                        setState(() {
                          state[0] = value;
                        });
                      }),
                      secondary:
                          const Icon(Icons.lightbulb, color: Colors.white),
                      title: Text(
                        switchs[0].name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      )),
                  SwitchListTile.adaptive(
                      value: state[1],
                      onChanged: ((value) {
                        setState(() {
                          state[1] = value;
                        });
                      }),
                      secondary: const Icon(Icons.charging_station_rounded,
                          color: Colors.white),
                      title: Text(
                        sockets[0].name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      )),
                  SwitchListTile.adaptive(
                      value: state[2],
                      onChanged: ((value) {
                        setState(() {
                          state[2] = value;
                        });
                      }),
                      secondary:
                          const Icon(Icons.lock_rounded, color: Colors.white),
                      title: Text(
                        locks[0].name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      )),
                  SwitchListTile.adaptive(
                      value: state[3],
                      onChanged: ((value) {
                        setState(() {
                          state[3] = value;
                        });
                      }),
                      secondary: const Icon(Icons.air, color: Colors.white),
                      title: Text(
                        aircons[0].name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      )),
                ],
              );
            },
          ),
          actions: <Widget>[
            // Column(
            //   children: [
            //     ListView.builder(
            //       itemCount: switchs.length,
            //       itemBuilder: (context, index) {
            //         return Card(
            //             elevation: 12.0,
            //             margin: const EdgeInsets.all(8.0),
            //             color: Colors.white60,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //             ),
            //             child: Obx(() =>
            // SwitchListTile.adaptive(
            //                 value: state[0],
            //                 onChanged: ((value) {
            //                   state[0] = value;
            //                 }),
            //                 secondary: const Icon(Icons.lightbulb,
            //                     color: Colors.white),
            //                 title: Text(
            //                   switchs[index].name,
            //                   style: const TextStyle(
            //                       fontSize: 20, color: Colors.black),
            //                 ))));
            //       },
            //     ),
            //     Card(
            //         elevation: 12.0,
            //         margin: const EdgeInsets.all(8.0),
            //         color: Colors.white60,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         ),
            //         child: Obx(() => SwitchListTile.adaptive(
            //             value: state[1],
            //             onChanged: ((value) {
            //               state[1] = value;
            //             }),
            //             secondary: const Icon(Icons.charging_station_rounded,
            //                 color: Colors.white),
            //             title: Text(
            //               sockets[0].name,
            //               style: const TextStyle(
            //                   fontSize: 20, color: Colors.black),
            //             )))),
            //     Card(
            //         elevation: 12.0,
            //         margin: const EdgeInsets.all(8.0),
            //         color: Colors.white60,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         ),
            //         child: Obx(() => SwitchListTile.adaptive(
            //             value: state[2],
            //             onChanged: ((value) {
            //               state[2] = value;
            //             }),
            //             secondary:
            //                 const Icon(Icons.lock_rounded, color: Colors.white),
            //             title: Text(
            //               locks[0].name,
            //               style: const TextStyle(
            //                   fontSize: 20, color: Colors.black),
            //             )))),
            //     Card(
            //         elevation: 12.0,
            //         margin: const EdgeInsets.all(8.0),
            //         color: Colors.white60,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         ),
            //         child: Obx(() => SwitchListTile.adaptive(
            //             value: state[3],
            //             onChanged: ((value) {
            //               state[3] = value;
            //             }),
            //             secondary: const Icon(Icons.air, color: Colors.white),
            //             title: Text(
            //               aircons[0].name,
            //               style: const TextStyle(
            //                   fontSize: 18, color: Colors.black),
            //             )))),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Get values from controllers and configure devices accordingly
                    String scenarioName = scenarioNameController.text;
                    // Retrieve other scenario details
                    var scenerio =
                        Scenario(scenarioName, Icons.add_circle, state);

                    // Implement logic to configure devices based on user input
                    setState(() {
                      scenerios.add(scenerio);
                    });
                    // Add the new scenario to the ListView or other data structure
                    saveScenarios();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Scenario'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffcef3c4),
        appBar: AppBar(
          title: const Text(
            'Scenarios',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                _showCustomScenarioDialog();
              },
            )
          ],
          backgroundColor: const Color(0xffa8daf9),
        ),
        body: isLoaded
            ? ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: scenerios.length,
                itemBuilder: (context, index) => Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      scenerios[index].name == ""
                          ? 'Custom ${index + 1}'
                          : scenerios[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    tileColor: Colors.white,
                    textColor: Colors.black87,
                    style: ListTileStyle.drawer,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteScenario(index);
                          },
                        ),
                      ],
                    ),
                    // Icon(scenerios[index].iconData, color: Colors.black),
                    onTap: () {
                      _chooseScene(index);
                    },
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _deleteScenario(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Confirm Delete'),
          content: const Text('Do you really want to delete this scenario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  scenerios.removeAt(index);
                  saveScenarios();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void sendData(String data) {
    channel.sink.add(data);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
