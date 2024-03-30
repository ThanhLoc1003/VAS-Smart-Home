import 'dart:convert';
import 'dart:ui';

import '../define_class/Rolldoor/rolldoorC.dart';

import 'define_class/Aircon/aircon.dart';
import 'define_class/Induction/induction.dart';
import 'define_class/Lock/lock.dart';
import 'define_class/Socket/socketC.dart';
import 'define_class/Switch/switchC.dart';

const Color kBgColor = Color(0xFFecf5fb);
const Color kOrangeColor = Color(0xFFF07662);
const Color kDarkGreyColor = Color(0xFF727C9B);
const Color kGreenColor = Color(0xFF47f03e);
const Color kBlueColor = Color(0xFF07062e);

String jsonSwitch =
    '[{"status":{"button1":false,"button2":true,"both":false},"_id": 2466864975,"name":"SW1","typeDevice":"Switch","room":"Phong trong","__v":0},{"status":{"button1":false,"button2":false,"both":false},"_id": 3042341065,"name":"SW2","typeDevice":"Switch","room":"Phong trong","__v":0}]';
var jsonDataSwitch = jsonDecode(jsonSwitch);

String jsonInduction =
    '[{"status":{"powerLevel":3,"power":false,"cooking":true,"stirfry":false,"timer":0},"_id": 759589757,"name":"Induction","typeDevice":"Induction","room":"Phong trong","__v":0}]';
var jsonDataInduction = jsonDecode(jsonInduction);

late dynamic firstCamera;

class Gateway {
  static String host = '115.79.196.171';
  static String portHttp = '1801';
  String portWebsocket = '1901';
}

class ServerAI {
  static String host = '115.79.196.171';
  static String port = '6788';
}

// List<WebSocketChannel> channel = [];
List<RolldoorC> rolldoors = [
  RolldoorC.fromJson({
    "_id": 2744259101,
    "name": "Gate1",
    "typeDevice": "Rolldoor1",
    "status": {"button1": false, "button2": false},
  })
];
List<Lock> locks = [
  Lock.fromJson({
    "_id": 1,
    "name": "lock",
    "typeDevice": "Lock",
    "status": {"button": false, "state": false},
  }),
];
List<SocketC> sockets = [
  SocketC.fromJson({
    "_id": 1,
    "name": "Socket",
    "typeDevice": "Socket",
    "status": {"button1": false, "button2": false, "both": false},
    "room": "Bedroom"
  }),
];
List<SwitchC> switchs = [
  SwitchC.fromJson({
    "_id": 1,
    "name": "switch",
    "typeDevice": "Switch",
    "status": {"button1": false, "button2": false, "both": false},
    "room": "Bedroom"
  }),
  SwitchC.fromJson({
    "_id": 2,
    "name": "switch",
    "typeDevice": "Switch",
    "status": {"button1": false, "button2": false, "both": false},
    "room": "Bedroom"
  }),
];
List<Induction> inductions = [];
List<Aircon> aircons = [
  Aircon.fromJson(
    {
      "_id": 1,
      "name": "aircon",
      "typeDevice": "Aircon",
      "status": {
        "on": false,
        "brand": "ExampleBrand",
        "mode": 2,
        "fanSpeed": 1,
        "temp": 25,
        // "temp_room": 22,
        // "humid": 40,
        "swing": false
      },
      "room": "Living Room"
    },
  )
];
