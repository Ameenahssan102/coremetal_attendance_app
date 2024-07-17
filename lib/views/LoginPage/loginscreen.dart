// ignore_for_file: avoid_print, prefer_const_constructors, constant_identifier_names

import 'package:face_app/custom/widgets/custom_text.dart';
import 'package:face_app/custom/widgets/custom_textfield.dart';
import 'package:face_app/providers/auth_provider.dart';
// import 'package:face_app/views/Home/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Values/values.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences? sharedPreferences;

  // final Version? version;

  const LoginScreen({
    super.key,
    this.sharedPreferences,
    // this.version,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // networkConnectivity.network(context);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer<LoginProvider>(builder: (context, authProvider, child) {
          return Form(
              key: _formKey,
              child: Stack(children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(children: [
                    SizedBox(height: size.height * 0.14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo2.png',
                          height: 180.0,
                          width: size.width * 1,
                          fit: BoxFit.fill,
                          color: AppColors.primaryDarkColor,
                          alignment: Alignment(0.00, 0.00),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: size.width,
                        height: 330,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CustomTextFormField(
                                        maxlines: 1,
                                        id: 0,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "UserName can't be empty";
                                        //   } else if (value.length < 5) {
                                        //     return "Invalid UserName";
                                        //   }
                                        //   return null;
                                        // },
                                        controller:
                                            authProvider.userIdController,
                                        labelColor: AppColors.hint2,
                                        hintText: "User Id",
                                        hintColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CustomTextFormField(
                                        maxlines: 1,
                                        id: 0,
                                        obscureText:
                                            visible == false ? true : null,
                                        suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                visible = !visible;
                                              });
                                            },
                                            child: Icon(
                                              visible == false
                                                  ? Iconsax.eye
                                                  : Iconsax.eye_slash,
                                              color: AppColors.hint
                                                  .withOpacity(.4),
                                            )),
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "Password can't be empty";
                                        //   } else if (value.length < 5) {
                                        //     return "Invalid Password";
                                        //   }
                                        //   return null;
                                        // },
                                        controller:
                                            authProvider.passwordController,
                                        hintText: "Password",
                                        hintColor: Colors.grey,
                                        labelColor: AppColors.hint2,
                                      ),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: AppColors.black
                                                .withOpacity(0.6)),
                                        text:
                                            "By logging in,you are agreeing to FACE APP's"),
                                  ])),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: AppColors.primaryDarkColor),
                                      text: "Terms and Conditions",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          const Terms = "";
                                          await canLaunchUrlString(Terms)
                                              ? launchUrlString(Terms)
                                              : print(
                                                  "error while opening Terms &Conditions");
                                        }),
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color:
                                              AppColors.black.withOpacity(0.6)),
                                      text: " and "),
                                  TextSpan(
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          color: AppColors.primaryDarkColor),
                                      text: "Privacy Policy",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          const Policy = "";
                                          await canLaunchUrlString(Policy)
                                              ? launchUrlString(Policy)
                                              : print(
                                                  "error while opening Policy");
                                        }),
                                ])),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  authProvider.login();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fixedSize: Size(size.width, 60),
                                    backgroundColor: AppColors.primaryDarkColor,
                                    textStyle: GoogleFonts.lato(fontSize: 20)),
                                child: Row(
                                  children: const [
                                    Icon(Iconsax.login, color: AppColors.white),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    customText(
                                      text: "Login",
                                      id: 1,
                                      color: AppColors.white,
                                    ),
                                  ],
                                )

                                // auth.load == false
                                //     ?
                                //     : SizedBox(
                                //         width: 35,
                                //         height: 35,
                                //         child: SpinKitPulse(
                                //           color: AppColors.white,
                                //           duration: Duration(seconds: 2),
                                //         ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    // ElevatedButton(onPressed: ()=>Timer(
                    //                 Duration(milliseconds: 800),
                    //                 () => Navigator.pushAndRemoveUntil(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (context) =>
                    //                              HomePage(id: 2,)),
                    //                     (route) => false)), child: customText(text: "support", id: 1)),
                    const SizedBox(
                      height: 60,
                    ),
                  ]),
                ),
              ]));
        }));
  }

// successfulMessage.then((response) {
//   if (response['status']) {
//     User user = response['data'];
//     provider.of<UserProvider>(context, listen: false).setUser(user);
//     Navigator.pushReplacementNamed(context, '/dashboard');
//   } else {
//     Alerts.showError("Login Failed ");
//   }
// });
}
