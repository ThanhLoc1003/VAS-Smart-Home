import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/../constants.dart';
import '../../screens/Camera/add_user_page.dart';
import '../../screens/Camera/delete_user_page.dart';
import '../../screens/Camera/mode_camera_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../screens/Camera/data_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

import '../../screens/Camera/add_link_camera.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../API/alarm_api.dart';

Future customDialog(context, String title, String desc) {
  return AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          showCloseIcon: true,
          title: title,
          desc: desc,
          // btnCancelOnPress: () {},
          btnOkOnPress: () {
            // setState(() {});
          })
      .show();
}

class CameraAiPage extends StatefulWidget {
  const CameraAiPage({super.key});

  @override
  State<CameraAiPage> createState() => _CameraAiPageState();
}

class _CameraAiPageState extends State<CameraAiPage> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('http://${ServerAI.host}:${ServerAI.port}'));
  // Uri.parse('https://www.youtube.com/watch?v=OVPTYcoSC78'));
  // Uri.parse('http://115.79.196.171:7777')
  late IO.Socket socket;
  late String role;
  bool isAlarm = false;
  var alarmApi = AlarmApi();
  void checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    role = prefs.getString('role')!;
    // print(role);
  }

  @override
  void initState() {
    super.initState();
    alarmApi.connect();
    checkRole();
    // Kết nối đến máy chủ Socket.IO
    socket =
        IO.io('http://${ServerAI.host}:${ServerAI.port}', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Lắng nghe sự kiện 'attendance_event'
    socket.on('attendance_event', (data) {
      // print('Received message: $data');
      // Xử lý thông điệp ở đây
      String message = data['message'];
      // Hiển thị thông điệp trong ứng dụng
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text('Notification'),
            content: Text(message,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });
    socket.on('detect_event', (data) {
      isAlarm = true;
      String message = data['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text('Notification'),
            content: Text(message,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      // print(message);
      setState(() {});
    });

    // Kết nối đến máy chủ
    socket.connect();
  }

  @override
  void dispose() {
    // Đóng kết nối khi ứng dụng được hủy
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 119, 130, 146),
      appBar: AppBar(
        title: const Text('Vas Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                controller.reload();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: WebViewWidget(controller: controller),
        ),
      ),
      floatingActionButton: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                tooltip: "Setup Mode Camera",
                onPressed: () {
                  role == 'All'
                      ? Get.to(const ModeCameraPage())
                      : customDialog(
                          context, 'Warning', 'You don\'t have access rights!');
                },
                child: const Icon(Icons.control_camera_outlined),
              ),
              const Text(
                "Mode",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                tooltip: "Add new person",
                onPressed: () {
                  role == 'All'
                      ? Get.to(TakePictureScreen(camera: firstCamera))
                      : customDialog(
                          context, 'Warning', 'You don\'t have access rights!');
                },
                child: const Icon(Icons.add_a_photo_rounded),
              ),
              const Text(
                "Add person",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                tooltip: "History Attendance",
                onPressed: () {
                  Get.to(const DataPage());
                },
                child: const Icon(Icons.history_sharp),
              ),
              const Text(
                "History",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                tooltip: "Delete Person",
                onPressed: () {
                  role == 'All'
                      ? Get.to(const DeleteUserPage())
                      : customDialog(
                          context, 'Warning', 'You don\'t have access rights!');
                },
                child: const Icon(Icons.delete_forever_rounded),
              ),
              const Text(
                "Delete Person",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                tooltip: "Add link camera",
                onPressed: () {
                  role == 'All'
                      ? Get.to(const ValidateStreamPage())
                      : customDialog(
                          context, 'Warning', 'You don\'t have access rights!');
                },
                child: const Icon(Icons.add_link_outlined),
              ),
              const Text(
                "Add link",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                tooltip: "Setup Mode Camera",
                backgroundColor: isAlarm
                    ? Colors.lightBlue
                    : const Color.fromARGB(255, 54, 68, 75),
                onPressed: () async {
                  var jsonData = '{"state": ${!isAlarm}}';
                  alarmApi.publish("vas-alarm-home", jsonData.toString());
                  await alarmApi.sendAlarm();
                  setState(() {
                    isAlarm = !isAlarm;
                  });
                },
                child: const Icon(Icons.alarm_add_rounded),
              ),
              Text(
                isAlarm ? "Alarm on" : "Alarm off",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
