import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/rolldoor_data.dart';
import '../common_widget/custom_card.dart';
import '../define_class/Aircon/aircon.dart';
import 'dart:async';

import 'package:restart_app/restart_app.dart';
import '../define_class/Rolldoor/rolldoorC.dart';
import '../define_class/Switch/switchC.dart';
// import '../main.dart';
import '../module/airconW.dart';
import '../module/socketW.dart';
import '../screens/Camera/camera_page.dart';
import '../screens/scene_page.dart';
import '../API/aircon_data.dart';
import '../API/induction_data.dart';
import '../API/lock_data .dart';
import '../API/socket_data.dart';
import '../API/switch_data.dart';
import '../constants.dart';
import '../define_class/Induction/induction.dart';
import '../define_class/Lock/lock.dart';
import '../define_class/Socket/socketC.dart';
import '../define_class/Weather/weather.dart';
import '../define_class/Weather/weatherdata.dart';
import '../module/lock_w.dart';
import '../module/switchW.dart';
import '../module/time.dart';
import '../module/weatherW.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

late WebSocketChannel channel;

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBgColor,
      body: ScreenBody(),
    );
  }
}

class ScreenBody extends StatefulWidget {
  const ScreenBody({super.key});
  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  var date = DateTime.now();

  void getTime() {
    final DateTime now = DateTime.now();
    setState(() {
      date = now;
    });
  }

  Weather weather = Weather();

  void getWeather() async {
    var weatherd = await WeatherData().getWeatherData();
    weather = weatherd;
    // setState(() {
    //   weather = weatherd;
    // });
  }

  void getSwitch() async {
    var switchd = await SwitchData().getSwitchData();
    //var switchd = jsonDataSwitch;
    switchs = switchd.map<SwitchC>((json) => SwitchC.fromJson(json)).toList();
    // setState(() {

    // });
  }

  void getRolldoor() async {
    var rolldoord = await RolldoorData().getRolldoorData();
    //var switchd = jsonDataSwitch;
    rolldoors =
        rolldoord.map<RolldoorC>((json) => RolldoorC.fromJson(json)).toList();
    // print(rolldoors[0].typeDevice);
    // setState(() {

    // });
  }

  void getLock() async {
    var lockd = await LockData().getLockData();
    //var switchd = jsonDataSwitch;
    locks = lockd.map<Lock>((json) => Lock.fromJson(json)).toList();
    // setState(() {

    // });
  }

  void getSocket() async {
    var socketd = await SocketData().getSocketData();
    //var switchd = jsonDataSwitch;
    sockets = socketd.map<SocketC>((json) => SocketC.fromJson(json)).toList();
    // setState(() {

    // });
  }

  void getInduction() async {
    var inductionD = await InductionData().getInductionData();
    inductions =
        inductionD.map<Induction>((json) => Induction.fromJson(json)).toList();
    // var inductionD = jsonDataInduction;
    // setState(() {

    // });
  }

  void getAircon() async {
    var aircond = await AirconData().getAirconData();
    //var switchd = jsonDataSwitch;
    // isLoad = true;
    aircons = aircond.map<Aircon>((json) => Aircon.fromJson(json)).toList();
    // setState(() {

    // });
    isRunning = true;
  }

  late String anh;
  int counter = 0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    if (date.hour > 5 && date.hour < 18) {
      anh = 'assets/images/daytime.jpg';
    } else {
      anh = 'assets/images/night.jpg';
    }
    channel = WebSocketChannel.connect(
        Uri.parse("ws://${Gateway.host}:${Gateway().portWebsocket}"));
    getWeather();

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      counter++;
      if (counter >= 2) {
        counter = 0;
      }
      getSwitch();
      getRolldoor();
      getSocket();
      getLock();
      getAircon();

      // getInduction();
      getTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (isRunning)
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white54,
              elevation: 0,
              title: const Center(
                child: Text(
                  'VAS Smart Home',
                  style: TextStyle(
                    color: Color.fromARGB(255, 134, 21, 179),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                Container(
                  height: size.height * 0.045,
                  width: size.width * 0.095,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            drawer: Drawer(
              backgroundColor: Colors.black87,
              child: ListView(children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 8.0,
                          left: 4.0,
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.play_circle_fill_outlined,
                    color: kDarkGreyColor,
                  ),
                  title: const Text("Scenarios",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    Get.to(const ScenarioPage());
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_outlined,
                    color: kDarkGreyColor,
                  ),
                  title: const Text("AI Camera",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    Get.to(const CameraAiPage());
                  },
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.nfc_outlined,
                //     color: kDarkGreyColor,
                //   ),
                //   title: const Text("Smart Lock",
                //       style: TextStyle(color: Colors.white, fontSize: 20)),
                //   onTap: () {
                //     Get.to(const NFCScreen());
                //   },
                // ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: kDarkGreyColor,
                  ),
                  title: const Text("Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('hostUrl', '');
                    Restart.restartApp();
                    // Get.off(const ScreenMain());
                  },
                ),
              ]),
            ),
            body: Stack(children: [
              Image.asset(
                anh,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              SafeArea(
                child: ListView(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTime(date, size),
                        buildWeather(weather, size),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    BuildRolldoor(size: size),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Text(
                        'Switch (${switchs.length} activate devices)',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    switchs.isNotEmpty
                        ? SizedBox(
                            height: size.height * 0.19,
                            child: ListView.builder(
                              itemCount: switchs.length,
                              itemBuilder: (context, index) {
                                return buildSwitch(
                                  size: size,
                                  dev: switchs[index],
                                  index: index,
                                );
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Text(
                        'Socket (${sockets.length} activate devices)',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    (sockets.isNotEmpty)
                        ? SizedBox(
                            height: size.height * 0.19,
                            child: ListView.builder(
                              itemCount: sockets.length,
                              itemBuilder: (context, index) {
                                return buildSocket(
                                  size: size,
                                  dev: sockets[index],
                                  index: index,
                                );
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Text(
                        'Lock (${locks.length} activate devices)',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    (locks.isNotEmpty)
                        ? SizedBox(
                            height: size.height * 0.19,
                            child: ListView.builder(
                              itemCount: locks.length,
                              itemBuilder: (context, index) {
                                return buildLock(
                                  size: size,
                                  dev: locks[index],
                                  index: index,
                                );
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Text(
                        'Aircon (${aircons.length} activate devices)',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    (aircons.isNotEmpty)
                        ? SizedBox(
                            height: size.height * 0.3,
                            child: ListView.builder(
                              itemCount: aircons.length,
                              itemBuilder: (context, index) {
                                return BuildAircon(
                                  size: size,
                                  index: index,
                                  dev: aircons[index],
                                );
                              },
                            ),
                          )
                        : Container()

                    // Expanded(
                    //   child: ListView.builder(
                    //       itemCount: inductions.length,
                    //       itemBuilder: (context, index) {
                    //         return BuildInduction(
                    //             size: size, dev: inductions[index]);
                    //       }),
                    // ),
                  ],
                ),
              ),
            ]),
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class BuildRolldoor extends StatelessWidget {
  const BuildRolldoor({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: AlignmentDirectional.centerStart,
        height: size.height * 0.17,
        decoration: BoxDecoration(
            color: kBgColor, borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Gate",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: '1 door',
                  state: rolldoors[0].status.button1,
                  value: 0,
                  type: rolldoors[0].typeDevice,
                  index: 0,
                ),
                const SizedBox(
                  width: 40,
                ),
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: '2 doors',
                  state: rolldoors[0].status.button2,
                  value: 0,
                  type: rolldoors[0].typeDevice,
                  index: 0,
                ),
              ],
            ),
          ],
        ));
  }
}
