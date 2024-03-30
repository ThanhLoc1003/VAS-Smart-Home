// ignore: file_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/body.dart';

import '../common_widget/custom_button.dart';
import '../common_widget/custom_formfield.dart';
import '../common_widget/custom_header.dart';
import '../common_widget/custom_richtext.dart';
import '../constants/app_colors.dart';
import '../constants/text_styles.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignInWidget());
  }
}

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShow = false;
  // @override
  // void initState() {
  //   super.initState();
  //   checkLoginStatus();
  // }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Get.off(const Screen());
      Get.off(() => const ScreenMain());
    }
  }

  // Future<void> _handleLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (_emailController.text == "admin" &&
  //       _passwordController.text == "vas1234") {
  //     await prefs.setBool('role', true);
  //     await prefs.setBool('isLoggedIn', true);
  //   }
  //   // else if (_emailController.text == "guest" &&
  //   //     _passwordController.text == "1234") {
  //   //   await prefs.setBool('role', false);
  //   //   await prefs.setBool('isLoggedIn', true);
  //   // }
  //   else {
  //     // CustomDialog(localContext, "Warning", "Account does not have access rights!");

  //     Get.snackbar(
  //       'Đăng nhập không thành công',
  //       'Vui lòng kiểm tra tên đăng nhập và mật khẩu.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  //   // Thực hiện xác thực tài khoản ở đây, ví dụ với một API đăng nhập.

  //   // Sau khi xác thực thành công, lưu trạng thái đăng nhập vào SharedPreferences.
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // await prefs.setBool('role', true);
  //   // await prefs.setBool('isLoggedIn', true);

  //   setState(() {
  //     // _isLoggedIn = true;
  //     checkLoginStatus();
  //   });
  // }

  Future<void> _signIn() async {
    // final response = await http.get(Uri.parse('http://192.168.224.191:3000/'));
    final response = await http.post(
      Uri.parse('http://115.79.196.171:1801/auth/login'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
        <String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // print(responseData["status"]);
      if (responseData["status"] == "FAILED") {
        Get.snackbar(
          responseData["message"],
          'Please try again',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.red,
          duration: const Duration(seconds: 5),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('name', responseData["data"][0]["name"]);
        await prefs.setString('role', responseData["data"][0]["role"]);
        checkLoginStatus();
      }
    }
    // Handle success or failure here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Sign In",
                  style: KTextStyle.headerTextStyle,
                )
              ],
            ),
          ),
          // CustomHeader(
          //   text: 'Log In.',
          //   onTap: () {
          //     // Navigator.pushReplacement(context,
          //     //     MaterialPageRoute(builder: (context) => const SignUp()));
          //   },
          // ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.09),
                    child: Image.asset("assets/images/login.png"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomFormField(
                    func: () {},
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    controller: _emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    func: () {},
                    headingText: "Password",
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    hintText: "At least 8 Character",
                    obsecureText: !isShow,
                    suffixIcon: IconButton(
                        icon: !isShow
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        }),
                    controller: _passwordController,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.symmetric(
                  //           vertical: 16, horizontal: 24),
                  //       child: InkWell(
                  //         onTap: () {},
                  //         child: Text(
                  //           "Forgot Password?",
                  //           style: TextStyle(
                  //               color: AppColors.blue.withOpacity(0.7),
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  AuthButton(
                    // onTap: () async {
                    //   User? user = await loginUsingEmailPassword(
                    //       email: _emailController.text,
                    //       password: _passwordController.text,
                    //       context: context);
                    //   if (user != null) {
                    //     // ignore: use_build_context_synchronously
                    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //         builder: (context) => const MainPage()));
                    //   }
                    // },
                    onTap: () async {
                      await _signIn();
                      // if (_emailController.text == "admin" &&
                      //     _passwordController.text == "vas1234") {
                      //   await _handleLogin();
                      // } else {
                      //   CustomDialog(context, "Warning",
                      //       "Account does not have access rights!");
                      // }
                    },

                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MainPage()));

                    text: 'Sign In',
                  ),
                  // CustomRichText(
                  //   discription: "Don't have an account? ",
                  //   text: "Sign Up",
                  //   onTap: () {
                  //     Get.to(() => const SignUpWidget());
                  //     // Navigator.pushReplacement(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (context) => const SignUpWidget()));
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Text(
    //           "Login",
    //           style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 28.0,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(
    //           height: 44.0,
    //         ),
    //         TextField(
    //           controller: _emailController,
    //           keyboardType: TextInputType.emailAddress,
    //           decoration: InputDecoration(
    //               hintText: "Email",
    //               prefixIcon: Icon(
    //                 Icons.email,
    //                 color: Colors.black,
    //               )),
    //         ),
    //         SizedBox(
    //           height: 26.0,
    //         ),
    //         TextField(
    //           controller: _passwordController,
    //           obscureText: true,
    //           decoration: InputDecoration(
    //               hintText: "Password",
    //               prefixIcon: Icon(
    //                 Icons.key,
    //                 color: Colors.black,
    //               )),
    //         ),
    //         SizedBox(
    //           height: 20.0,
    //         ),
    //         CustomRichText(
    //           discription: "Don't already Have an account? ",
    //           text: "Sign Up",
    //           onTap: () {
    //             Navigator.pushReplacement(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => const SignUpWidget()));
    //           },
    //         ),
    //         Container(
    //           width: double.infinity,
    //           child: RawMaterialButton(
    //             fillColor: Color(0xFF0069FE),
    //             elevation: 0.0,
    //             padding: EdgeInsets.symmetric(vertical: 20.0),
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12.0)),
    //             // onPressed: () async {
    //             //   User? user = await loginUsingEmailPassword(
    //             //       email: _emailController.text,
    //             //       password: _passwordController.text,
    //             //       context: context);
    //             //   if (user != null) {
    //             //     // ignore: use_build_context_synchronously
    //             //     Navigator.of(context).pushReplacement(
    //             //         MaterialPageRoute(
    //             //             builder: (context) => const MainPage()));
    //             //   }
    //             // },
    //             onPressed: () {
    //               Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                   builder: (context) => const MainPage()));
    //             },
    //             child: const Text(
    //               "Login",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 18.0,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ]),
    // );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // static Future<User?> registerUsingEmailPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;
  //   try {
  //     UserCredential userCredential = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     user = userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == "user-not-found") {
  //       //print("No User found for that email");
  //     }
  //   }
  //   return user;
  // }
  // void register(String email, password) async {
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } catch (e) {
  //     Get.snackbar("About User", "User message",
  //         backgroundColor: Colors.redAccent,
  //         snackPosition: SnackPosition.BOTTOM,
  //         titleText: const Text(
  //           "Account creation failed",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         messageText: Text(
  //           e.toString(),
  //           style: const TextStyle(color: Colors.white),
  //         ));
  //   }
  // }

  Future<void> _signUp() async {
    final response = await http.post(
      Uri.parse('http://115.79.196.171:1801/auth/register'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'name': _userName.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // print(responseData["status"]);
      if (responseData["status"] == "FAILED") {
        Get.snackbar(
          responseData["message"],
          'Please try again',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.red,
          duration: const Duration(seconds: 5),
        );
        // showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           title: Text(
        //             responseData["message"],
        //             style: TextStyle(color: Colors.redAccent),
        //           ),
        //         ));
      } else {
        Get.off(() => const LoginPage());
      }
    }

    // Handle success or failure here
  }

  bool isShow1 = false, isShow2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          CustomHeader(
              text: 'Sign Up.',
              onTap: () {
                // AuthController.instance.register(userName, password);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 200,
                  //   width: MediaQuery.of(context).size.width * 0.8,
                  //   margin: EdgeInsets.only(
                  //       left: MediaQuery.of(context).size.width * 0.09),
                  //   child: Image.asset("assets/images/login.png"),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormField(
                    func: () {},
                    headingText: "User Name",
                    hintText: "Name",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    controller: _userName,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    func: () {},
                    headingText: "Email",
                    hintText: "Email",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    func: () {},
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    controller: _confirmPasswordController,
                    headingText: "Password",
                    hintText: "At least 8 Character",
                    obsecureText: !isShow1,
                    suffixIcon: IconButton(
                        icon: !isShow1
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isShow1 = !isShow1;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    func: () {
                      // print("drgdfgdfg");
                    },
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    controller: _passwordController,
                    headingText: "Confirm Password",
                    hintText: "At least 8 Character",
                    obsecureText: !isShow2,
                    suffixIcon: IconButton(
                        icon: !isShow2
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isShow2 = !isShow2;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AuthButton(
                    onTap: () async {
                      _confirmPasswordController.text !=
                              _passwordController.text
                          ? Get.snackbar("Those passwords didn't match",
                              'Please try again',
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Colors.red,
                              duration: const Duration(seconds: 5))
                          : await _signUp();
                      // User? user = await registerUsingEmailPassword(
                      //   email: _emailController.text,
                      //   password: _passwordController.text,
                      // );
                      // if (user != null) {
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //       builder: (context) => const LoginPage()));
                      // }
                    },
                    text: 'Sign Up',
                  ),
                  // CustomRichText(
                  //   discription: 'Already Have an account? ',
                  //   text: 'Log In here',
                  //   onTap: () {
                  //     Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const LoginPage()));
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
