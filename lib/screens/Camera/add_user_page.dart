// A screen that allows users to take a picture using a given camera.
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late bool _isFrontCamera;
  late TextEditingController _imageNameController;
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _isFrontCamera = false;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _imageNameController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _imageNameController.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    final CameraDescription newDescription = _isFrontCamera
        ? await _getFirstRearCamera()
        : await _getFirstFrontCamera();

    if (_controller.value.isRecordingVideo) {
      return;
    }
    await _controller.dispose();
    _controller = CameraController(newDescription, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  Future<CameraDescription> _getFirstFrontCamera() async {
    final cameras = await availableCameras();
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        return camera;
      }
    }
    return cameras.first;
  }

  Future<CameraDescription> _getFirstRearCamera() async {
    final cameras = await availableCameras();
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        return camera;
      }
    }
    return cameras.first;
  }

  bool isNameValid(String name) {
    // Sử dụng regex để kiểm tra chuỗi không chứa ký tự đặc biệt hoặc dấu
    RegExp regex = RegExp(r'^[a-zA-Z0-9_ ]+$');
    return regex.hasMatch(name);
  }

  // Function to upload the image to the server
  Future<String> uploadImage(File imageFile, String imageName) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://${ServerAI.host}:${ServerAI.port}/upload'));
    // Uri.parse('http://192.168.1.104:7788/upload'));

    String fileName = '$imageName.jpg';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path,
        filename: fileName));
    request.fields['name'] = imageName;
    var response = await request.send();
    if (response.statusCode == 200) {
      // print("sffgdfg${response.stream.toString()}");
      final String responseData = await response.stream.bytesToString();
      // print("Data:" + responseData);
      return responseData;
      // print('Image uploaded successfully!');
    } else {
      return '';
    }
    // print('Failed to upload image. Status code: ${response.statusCode}');
  }
  // try {
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     return response.stream.bytesToString();
  //     print('Image uploaded successfully!');
  //   } else {
  //     return '';
  //     print('Failed to upload image. Status code: ${response.statusCode}');
  //   }
  // } catch (e) {
  //   print('Error uploading image: $e');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new person')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _imageNameController,
                    decoration: const InputDecoration(
                      labelText: 'Image Name',
                      helperText:
                          "Name no special characters(Example: Hoang Long)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(child: CameraPreview(_controller)),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleCamera,
            child: const Icon(Icons.switch_camera),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                String imageName = _imageNameController.text;
                if (imageName.isEmpty) {
                  // Show a warning if the image name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an name'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                if (!isNameValid(imageName)) {
                  // Tên hợp lệ, thực hiện các thao tác khác ở đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an suitable name'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                final image = await _controller.takePicture();
                if (!mounted) return;
                File imageFile = File(image.path);
                var res = await uploadImage(imageFile, imageName);
                // print("dgdfgdfgres:" + res);
                if (res == 'File uploaded successfully!') {
                  await Get.to(DisplayPictureScreen(imagePath: imageFile.path));
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Image uploaded successfully!'),
                  //     duration: Duration(seconds: 2),
                  //   ),
                  // );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(res),
                    duration: const Duration(seconds: 3),
                  ));
                }

                // Show a success message upon successful upload
              } catch (e) {
                log(e.toString());
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
