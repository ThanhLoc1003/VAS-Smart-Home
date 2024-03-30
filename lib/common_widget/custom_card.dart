import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../API/aircon_data.dart';
import '../API/lock_data .dart';
import '../API/socket_data.dart';
import '../API/switch_data.dart';
import '../constants.dart';

import '../define_class/Aircon/aircon.dart';
import '../define_class/Lock/lock.dart';
import '../define_class/Rolldoor/rolldoorC.dart';
import '../define_class/Socket/socketC.dart';
import '../define_class/Switch/switchC.dart';
import '../screens/body.dart';

import 'package:syncfusion_flutter_sliders/sliders.dart';

var command = {
  "Temp": {"min": 0, "max": 30, "interval": 5.0},
  "Mode": {"min": 0, "max": 5, "interval": 1.0},
  "FanSpeed": {"min": 0, "max": 5, "interval": 1.0},
};

// ignore: must_be_immutable
class CustomCard extends StatefulWidget {
  CustomCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.state,
      required this.value,
      required this.type,
      required this.index});

  final IconData icon;
  final String title;
  bool state;
  int value;
  String type;
  int index;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    sliderValue = widget.value.obs;

    super.initState();
  }

  var sliderValue = 0.obs;
  bool canPress = true;

  void _handleTap() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Control successfully'),
      duration: Duration(milliseconds: 500),
    ));
    setState(() {
      updateData();
      canPress = false; // Disable tapping
    });
    // Reset tapping after 1 second
    Timer(const Duration(seconds: 1), () {
      setState(() {
        canPress = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (['FanSpeed', 'Temp', 'Temp_room', 'Humidity', 'Mode']
        .contains(widget.title)) {
      return GestureDetector(
        onTap: () {
          _showSliderDialog(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: size.height * 0.09,
            width: size.width * 0.25,
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon),
                Text(
                  '${widget.title}: ${widget.value}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: canPress ? () => _handleTap() : null,
        splashColor: Colors.yellowAccent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: size.height * 0.08,
            width: size.width * 0.25,
            color: widget.state ? Colors.greenAccent : Colors.grey,
            // padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void updateData() {
    if (widget.type == "Switch") {
      updateState(widget.title, switchs);
      // print(json.encode(SwitchC(
      //         switchs[widget.index].id,
      //         switchs[widget.index].name,
      //         switchs[widget.index].status,
      //         switchs[widget.index].typeDevice)
      //     .toJson()));
      updateSwitch(switchs[widget.index]).toString();
      channel.sink.add(json.encode(SwitchC(
              switchs[widget.index].id,
              switchs[widget.index].name,
              switchs[widget.index].status,
              switchs[widget.index].typeDevice)
          .toJson()));
    } else if (widget.type == "Socket") {
      updateState(widget.title, sockets);
      updateSocket(sockets[widget.index]).toString();
      channel.sink.add(json.encode(SocketC(
              sockets[widget.index].id,
              sockets[widget.index].name,
              sockets[widget.index].status,
              sockets[widget.index].typeDevice)
          .toJson()));
    } else if (widget.type == "Rolldoor") {
      updateState(widget.title, rolldoors);
      // log(json.encode(RolldoorC(
      //         rolldoors[widget.index].status,
      //         rolldoors[widget.index].id,
      //         rolldoors[widget.index].name,
      //         rolldoors[widget.index].typeDevice)
      //     .toJson()));

      // updateRolldoor(rolldoors[widget.index]).toString();
      channel.sink.add(json.encode(RolldoorC(
              rolldoors[widget.index].status,
              rolldoors[widget.index].id,
              rolldoors[widget.index].name,
              rolldoors[widget.index].typeDevice)
          .toJson()));
    } else if (widget.type == "Lock") {
      if (widget.title != "State") {
        updateState(widget.title, locks);
        updateLock(locks[widget.index]).toString();
        channel.sink.add(json.encode(Lock(
          locks[widget.index].status,
          locks[widget.index].id,
          locks[widget.index].name,
          locks[widget.index].typeDevice,
        ).toJson()));
      }
    } else if (widget.type == "Aircon") {
      updateState(widget.title, aircons);
      updateAircon(aircons[widget.index]).toString();
      channel.sink.add(json.encode(Aircon(
              aircons[widget.index].id,
              aircons[widget.index].name,
              aircons[widget.index].typeDevice,
              aircons[widget.index].status)
          .toJson()));
      // print(json.encode(Aircon(
      //         aircons[widget.index].id,
      //         aircons[widget.index].name,
      //         aircons[widget.index].typeDevice,
      //         aircons[widget.index].status)
      //     .toJson()));
    }
  }

  void updateState(String title, dynamic device) {
    switch (title) {
      case "Button":
        device[widget.index].status.button =
            !device[widget.index].status.button;
        break;
      case "Button1" || "1 door":
        device[widget.index].status.button1 =
            !device[widget.index].status.button1;

        break;
      case "Button2" || "2 doors":
        device[widget.index].status.button2 =
            !device[widget.index].status.button2;

        break;
      case "All":
        if (widget.state == false) {
          device[widget.index].status.button1 = true;
          device[widget.index].status.button2 = true;
        } else {
          device[widget.index].status.button1 = false;
          device[widget.index].status.button2 = false;
        }
        break;
      case "Power":
        device[widget.index].status.on = !device[widget.index].status.on;
        // inductions[0].status.power = !inductions[0].status.power;
        break;
      case "Swing":
        device[widget.index].status.swing = !device[widget.index].status.swing;
        // inductions[0].status.power = !inductions[0].status.power;
        break;
      case "Temp":
        device[widget.index].status.temp = sliderValue.value;
        break;
      case "Mode":
        device[widget.index].status.mode = sliderValue.value;
        break;
      case "FanSpeed":
        device[widget.index].status.fanSpeed = sliderValue.value;
        break;
      case "Cooking":
        device[0].status.cooking = !device[0].status.cooking;
        break;
      default:
      // device[0].status.stirfry = !device[0].status.stirfry;
    }
  }

  void _showSliderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adjust ${widget.title}'),
          content: const Text('Slide to adjust the value:'),
          actions: <Widget>[
            Obx(
              () => SfSlider(
                min: command[widget.title]?['min'],
                max: command[widget.title]?['max'],
                value: sliderValue.value.toDouble(),
                interval: command[widget.title]!['interval']?.toDouble(),
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  sliderValue.value = value.toInt();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      updateData();
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // void sendData(String data) {
  //   channel.sink.add(data);
  // }

  // @override
  // void dispose() {
  //   channel.sink.close();
  //   super.dispose();
  // }
}
