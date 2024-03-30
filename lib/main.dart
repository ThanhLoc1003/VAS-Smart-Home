import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/foundation.dart';
import 'package:vas_home/screens/input_gateway_ip.dart';
import '../constants.dart';

// import 'package:nfc_host_card_emulation/nfc_host_card_emulation.dart';

// late NfcState _nfcState;
Future<void> main() async {
  // This works only on Android

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences prefs = await SharedPreferences.getInstance();

  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;

  // _nfcState = await NfcHce.checkDeviceNfcState();

  // if (_nfcState == NfcState.enabled) {
  //   await NfcHce.init(
  //     aid: Uint8List.fromList([0xA0, 0x00, 0xDA, 0xDA, 0xDA, 0xDA, 0xDA]),
  //     permanentApduResponses: true,
  //     listenOnlyConfiguredPorts: false,
  //   );
  // }
  // Check for internet connectivity
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kReleaseMode) exit(1);
    };

    runApp(
      GetMaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const InputGatewayIP()
          // ModeCameraPage(),
          // isLoggedIn ? const ScreenMain() : const LoginPage(),
          ),
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => // Wrap your app
      //       GetMaterialApp(
      //     debugShowCheckedModeBanner: false,
      //     useInheritedMediaQuery: true,
      //     locale: DevicePreview.locale(context),
      //     builder: DevicePreview.appBuilder,
      //     theme: ThemeData.light(),
      //     darkTheme: ThemeData.dark(),
      //     home:
      //         // ModeCameraPage(),
      //         isLoggedIn ? const ScreenMain() : const LoginPage(),
      //   ),
      // ),
    );
  } else {
    // Show an alert for no internet connectivity
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text('No Internet Connection'),
              content: const Text(
                  'Please check your internet connection and try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class NFCScreen extends StatefulWidget {
//   const NFCScreen({super.key});

//   @override
//   State<NFCScreen> createState() => _NFCScreenState();
// }

// class _NFCScreenState extends State<NFCScreen> {
//   bool apduAdded = false;
//   final port = 0;
//   List<int> data = [1, 2, 3, 4, 0, 0];
//   String lockStatus = 'Unknown';
//   String attemptLeft = '5';
//   int LockCode = 2;
//   int UnlockCode = 1;
//   int WrongPassCode = 3;
//   int EmergencyCode = 4;
//   int LockedAndChangedCode = 6;
//   String userInputPassword = '';
//   bool switch1 = false;
//   bool switch2 = false;
//   bool changeMode = false;
//   final _textController = TextEditingController();
//   NfcApduCommand? nfcApduCommand;

//   @override
//   void initState() {
//     super.initState();

//     NfcHce.stream.listen((command) {
//       setState(() => nfcApduCommand = command);
//       if (nfcApduCommand != null) {
//         setState(() {
//           lockStatus = changeDialogText(nfcApduCommand!.data);
//           switch2 = false;
//           data[5] = 0;
//         });
//       }
//     });
//   }

//   String changeDialogText(Uint8List? nfcApduData) {
//     if (nfcApduData![0] == LockCode) {
//       return 'Locked';
//     } else if (nfcApduData[0] == UnlockCode) {
//       return 'Unlocked';
//     } else if (nfcApduData[0] == WrongPassCode) {
//       return 'Wrong Password, attempt(s) left: ${nfcApduData[1]}';
//     } else if (nfcApduData[0] == EmergencyCode) {
//       return 'Too many wrong attempts, try again in 5 minutes';
//     } else if (nfcApduData[0] == LockedAndChangedCode) {
//       return 'Locked and changed password';
//     } else {
//       return 'Unknown';
//     }
//   }

//   List<int> stringToIntList(String stringg, bool switched1, bool switched2) {
//     String revString;
//     revString = String.fromCharCodes(stringg.runes.toList().reversed);
//     int a = int.parse(revString);
//     int i = 0;
//     int ten = 10;
//     final intList = [0, 0, 0, 0, 0, 0];
//     while (a > 0) {
//       int digit = a % 10;
//       a = a ~/ ten;
//       intList[i] = digit;
//       i++;
//     }
//     if (switched1) intList[4] = 1;
//     if (switched2) intList[5] = 1;
//     return intList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final body = _nfcState == NfcState.enabled
//         ? Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'NFC is ${_nfcState.name}',
//                   style: const TextStyle(fontSize: 15),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20),
//                   child: TextField(
//                     maxLength: 4,
//                     maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.digitsOnly
//                     ],
//                     controller: _textController,
//                     decoration: InputDecoration(
//                       hintText: 'Type 4 Digits of Password',
//                       border: const OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         onPressed: () => _textController.clear(),
//                         icon: const Icon(Icons.clear),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 if (!apduAdded) ...[
//                   Column(
//                     children: [
//                       MaterialButton(
//                         onPressed: () {
//                           setState(
//                               () => userInputPassword = _textController.text);
//                           setState(() => data = stringToIntList(
//                               userInputPassword, switch1, switch2));
//                           _textController.clear();
//                         },
//                         color: Colors.blue,
//                         child: const Text(
//                           'Save',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       if (nfcApduCommand != null) ...[
//                         Row(
//                           children: [
//                             const SizedBox(width: 20),
//                             Column(
//                               children: [
//                                 const Text('Auto Locking Mode'),
//                                 const Text('(effective after unlock)',
//                                     style: TextStyle(fontSize: 10)),
//                                 Switch(
//                                   value: switch1,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       switch1 = value;
//                                       if (value) {
//                                         data[4] = 1;
//                                       } else {
//                                         data[4] = 0;
//                                       }
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             if (lockStatus == 'Unlocked' &&
//                                 switch1 == false) ...[
//                               Column(
//                                 children: [
//                                   const Text('Change password after locking'),
//                                   Switch(
//                                     value: switch2,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         switch2 = value;
//                                         if (value) {
//                                           data[5] = 1;
//                                         } else {
//                                           data[5] = 0;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                             const SizedBox(width: 20),
//                           ],
//                         )
//                       ]
//                     ],
//                   ),
//                 ],
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   height: 150,
//                   width: 250,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                         apduAdded ? Colors.redAccent : Colors.greenAccent,
//                       ),
//                     ),
//                     onPressed: () async {
//                       if (apduAdded == false) {
//                         await NfcHce.addApduResponse(port, data);
//                       } else {
//                         await NfcHce.removeApduResponse(port);
//                       }
//                       setState(() => apduAdded = !apduAdded);
//                     },
//                     child: FittedBox(
//                       child: Text(
//                         apduAdded
//                             ? 'Stop sending password'
//                             : 'Send password\n $userInputPassword',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 26,
//                           color: apduAdded ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 if (nfcApduCommand != null)
//                   Text(
//                     'Lock Status: $lockStatus',
//                     style: const TextStyle(fontSize: 20),
//                     textAlign: TextAlign.center,
//                   ),
//               ],
//             ),
//           )
//         : Center(
//             child: Text(
//               'Oh no...\nNFC is ${_nfcState.name}',
//               style: const TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//           );

//     return GestureDetector(
//       onTap: () {
//         // FocusScopeNode currentFocus = FocusScope.of(context);
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
//         home: Scaffold(
//           appBar: AppBar(
//             actions: const [],
//             title: const Text('Smart Lock '),
//           ),
//           body: body,
//         ),
//       ),
//     );
//   }
// }
