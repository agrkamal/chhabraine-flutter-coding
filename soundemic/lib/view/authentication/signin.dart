import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:soundemic/constant/routes.dart';
import 'package:soundemic/constant/colors.dart';
import '../../controller/auth_controller.dart';

class SignIn extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  void signIn() {
    if (authController.signInformKey.currentState.validate()) {
      authController.signIn('${authController.emailController.text}',
          '${authController.passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          // Gradient background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kbackground2, kwhite, kbackground2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              transform: GradientRotation(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 90, bottom: 50),
                height: 130,
                // width: Get.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/logo.jpg',
                        fit: BoxFit.cover,
                        width: 120,
                      ),
                    ),
                    Text(
                      'SoundEmic',
                      style: TextStyle(
                          fontFamily: GoogleFonts.aclonica().fontFamily,
                          fontSize: 22.0),
                    ),
                  ],
                ),
              ),
              authController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: authController.signInformKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Email TextField
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    controller: authController.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(
                                          authController.passwordFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10.0,
                                          borderSide: BorderSide(width: 3.0)),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty || value == null) {
                                        return 'Enter Your Email';
                                      } else if (!RegExp(
                                              r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                          .hasMatch(value)) {
                                        return 'Email is not corrent';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Password TextFormField
                                Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: TextFormField(
                                      controller:
                                          authController.passwordController,
                                      obscureText: authController.obsure.value,
                                      focusNode:
                                          authController.passwordFocusNode,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        suffix: TextButton(
                                          onPressed: () {
                                            authController.obsure.value =
                                                !authController.obsure.value;
                                          },
                                          child: Text(
                                            '${authController.obsure.value ? 'Show' : 'Hide'}',
                                            style: TextStyle(
                                                color:
                                                    authController.obsure.value
                                                        ? kbackground1
                                                        : kblack),
                                          ),
                                        ),
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 7.0,
                                          horizontal: 15.0,
                                        ),
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          gapPadding: 10.0,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty || value == null) {
                                          return 'Enter Password';
                                        } else if (value.length < 6) {
                                          return 'Password is too short';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    authController.forgotPassword(
                                        authController.emailController.text);
                                  },
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      color: kblack,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    authController.signInformKey.currentState
                                        .dispose();
                                    Get.offAndToNamed(Routes.SIGNUP);
                                    authController.emailController.clear();
                                    authController.passwordController.clear();
                                  },
                                  child: Text(
                                    'Create Account SignUp',
                                    style: TextStyle(
                                      color: kbackground1,
                                      decorationColor: kblack,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        BoxShadow(
                                            color: kblack,
                                            blurRadius: 1.0,
                                            offset: Offset(0, 1.8)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              // Sign In button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                // padding: EdgeInsets.symmetric(horizontal: 15.0),
                width: Get.width,
                decoration: BoxDecoration(
                    color: kbackground2,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7.0,
                        offset: Offset(0, 1.7),
                        color: kblack,
                      ),
                    ],
                    border: Border.all(
                      color: kbackground2,
                    )),
                child: TextButton.icon(
                  onPressed: () {
                    signIn();
                  },
                  icon: Icon(
                    Icons.login,
                    color: kblack,
                  ),
                  label: Text(
                    'Sign In',
                    style: TextStyle(color: kblack, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
