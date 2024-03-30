import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/../screens/Camera/camera_page.dart';

import '../../constants.dart';

class ModeCameraPage extends StatefulWidget {
  const ModeCameraPage({super.key});

  @override
  State<ModeCameraPage> createState() => _ModeCameraPageState();
}

class _ModeCameraPageState extends State<ModeCameraPage> {
  String selectedMode = "At home";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));

  void _sendDataToServer() async {
    String url =
        "http://${ServerAI.host}:${ServerAI.port}/mode_camera"; // Thay thế bằng URL của server của bạn

    Map<String, dynamic> data = {
      "camera_mode": selectedMode,
      "start_time": DateFormat('HH:mm dd-MM-yyyy').format(startTime),
      "end_time": DateFormat('HH:mm dd-MM-yyyy').format(endTime),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );

      if (response.statusCode == 200) {
        Get.off(const CameraAiPage());
        // Get.snackbar("Successed", response.body,
        //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      } else {
        Get.snackbar("Failed", "Please try again",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        // print("Failed to set mode camera. Status code: ${response.statusCode}");
      }
    } catch (error) {
      Get.snackbar("Failed", "Please try again",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);

      // print("Error: $error");
    }
  }

  Future<void> _selectStartTime(BuildContext context, bool flag) async {
    if (flag) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != startTime) {
        setState(() {
          startTime = DateTime(picked.year, picked.month, picked.day,
              startTime.hour, startTime.minute);
        });
      }
    } else {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(startTime),
      );
      if (pickedTime != null) {
        setState(() {
          startTime = DateTime(
            startTime.year,
            startTime.month,
            startTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context, bool flag) async {
    if (flag) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != endTime) {
        setState(() {
          endTime = DateTime(picked.year, picked.month, picked.day,
              endTime.hour, endTime.minute);
        });
      }
    } else {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(endTime),
      );
      if (pickedTime != null) {
        setState(() {
          endTime = DateTime(
            endTime.year,
            endTime.month,
            endTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget OutHome() {
    //   return Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "Start Time: ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectStartTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(startTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //           const SizedBox(width: 15),
    //           ElevatedButton(
    //             onPressed: () => _selectStartTime(context, true),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Icons.calendar_month_outlined,
    //                   size: 30,
    //                   color: Colors.black,
    //                 ),
    //                 Text(
    //                   DateFormat('EEE, M/d/y').format(startTime),
    //                   style: const TextStyle(fontSize: 20, color: Colors.black),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "End Time:   ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectEndTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(endTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //           const SizedBox(width: 15),
    //           ElevatedButton(
    //             onPressed: () => _selectEndTime(context, true),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Icons.calendar_month_outlined,
    //                   size: 30,
    //                   color: Colors.black,
    //                 ),
    //                 Text(
    //                   DateFormat('EEE, M/d/y').format(endTime),
    //                   style: const TextStyle(fontSize: 20, color: Colors.black),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "End Time:   ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectEndTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(endTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //           const SizedBox(width: 15),
    //           ElevatedButton(
    //             onPressed: () => _selectEndTime(context, true),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Icons.calendar_month_outlined,
    //                   size: 30,
    //                   color: Colors.black,
    //                 ),
    //                 Text(
    //                   DateFormat('EEE, M/d/y').format(endTime),
    //                   style: const TextStyle(fontSize: 20, color: Colors.black),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // }

    // Widget InHome() {
    //   return Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "Start Time: ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectStartTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(startTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "End Time:   ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectEndTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(endTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //           const SizedBox(width: 15),
    //           ElevatedButton(
    //             onPressed: () => _selectEndTime(context, true),
    //             child: Row(
    //               children: [
    //                 const Icon(
    //                   Icons.calendar_month_outlined,
    //                   size: 30,
    //                   color: Colors.black,
    //                 ),
    //                 Text(
    //                   DateFormat('EEE, M/d/y').format(endTime),
    //                   style: const TextStyle(fontSize: 20, color: Colors.black),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "End Time:   ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           ElevatedButton(
    //               onPressed: () => _selectEndTime(context, false),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Icon(
    //                     Icons.watch_later_outlined,
    //                     size: 30,
    //                     color: Colors.black,
    //                   ),
    //                   Text(
    //                     DateFormat('HH:mm').format(endTime),
    //                     style:
    //                         const TextStyle(fontSize: 20, color: Colors.black),
    //                   ),
    //                 ],
    //               )),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 15),
    //           const Text(
    //             "Repeat: ",
    //             style: TextStyle(fontSize: 26, color: Colors.blueAccent),
    //           ),
    //           CheckboxListTile.adaptive(value: true, onChanged: (value) {})
    //         ],
    //       ),
    //     ],
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Mode Setup"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Mode: ",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  const SizedBox(width: 15),
                  DropdownButton<String>(
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                    value: selectedMode,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMode = newValue!;
                      });
                    },
                    items: <String>['At home', 'Out home']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  const Text(
                    "Start Time: ",
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  ElevatedButton(
                      onPressed: () => _selectStartTime(context, false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                          Text(
                            DateFormat('HH:mm').format(startTime),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () => _selectStartTime(context, true),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        Text(
                          DateFormat('EEE, M/d/y').format(startTime),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  const Text(
                    "End Time:   ",
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  ElevatedButton(
                      onPressed: () => _selectEndTime(context, false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                          Text(
                            DateFormat('HH:mm').format(endTime),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () => _selectEndTime(context, true),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        Text(
                          DateFormat('EEE, M/d/y').format(endTime),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.greenAccent)),
                  onPressed: () => startTime.isBefore(endTime)
                      ? _sendDataToServer()
                      : Get.snackbar(
                          "Error", "Start time must be before end time",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red),
                  //  startTime.isAfter(endTime)
                  //     ? ()=> _sendDataToServer
                  //     : Get.snackbar("Error", message);,
                  child: const SizedBox(
                      width: 100,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Save",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Icon(
                            Icons.save_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
