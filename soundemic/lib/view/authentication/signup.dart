import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundemic/constant/colors.dart';
import 'package:get/get.dart';
import 'package:soundemic/constant/routes.dart';

import '../../controller/auth_controller.dart';

class SignUp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  void signUp() {
    if (authController.signUpformKey.currentState.validate()) {
      authController.signUp('${authController.emailController.text}',
          '${authController.passwordController.text}');
    }
  }

  Widget imageAvtar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          GetBuilder<AuthController>(
            builder: (controller) {
              return CircleAvatar(
                radius: 55.0,
                backgroundColor: kblack,
                backgroundImage: authController.imageFile != null
                    ? FileImage(authController.imageFile.value)
                    : null,
                child: authController.imageFile == null
                    ? GestureDetector(
                        onTap: () {
                          authController.pickImage();
                        },
                        child: Icon(
                          Icons.photo_camera_rounded,
                          size: 50,
                          color: kwhite,
                        ),
                      )
                    : null,
              );
            },
          ),
          if (authController.imageFile != null)
            Positioned(
              top: 0.0,
              right: 0.0,
              child: CircleAvatar(
                backgroundColor: kbackground1,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: kblack,
                  ),
                  onPressed: () {
                    authController.pickImage();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Container(
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
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 30),
                    child: Form(
                      key: authController.signUpformKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Image
                          Center(child: imageAvtar()),
                          // Email TextField
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: authController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gapPadding: 10.0,
                                    borderSide: BorderSide(width: 3.0)),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                    authController.passwordFocusNode);
                              },
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: authController.passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              focusNode: authController.passwordFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                    authController.confirmPasswordFocusNode);
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gapPadding: 10.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
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

                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller:
                                    authController.confirmPasswordController,
                                obscureText: authController.obsure.value,
                                focusNode:
                                    authController.confirmPasswordFocusNode,
                                decoration: InputDecoration(
                                  suffix: TextButton(
                                    onPressed: () {
                                      authController.obsure.value =
                                          !authController.obsure.value;
                                    },
                                    child: Text(
                                      '${authController.obsure.value ? 'Show' : 'Hide'}',
                                      style: TextStyle(
                                          color: authController.obsure.value
                                              ? kbackground1
                                              : kblack),
                                    ),
                                  ),
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 7.0,
                                    horizontal: 15.0,
                                  ),
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
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
                                  } else if (value !=
                                      authController.passwordController.text) {
                                    return 'Password does not match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              authController.signUpformKey.currentState
                                  .dispose();
                              Get.offAndToNamed(Routes.SIGNIN);
                              authController.emailController.clear();
                              authController.passwordController.clear();
                            },
                            child: Text(
                              'Already have an Account SignIn?',
                              style: TextStyle(
                                color: kbackground1,
                                decorationColor: kblack,
                                fontSize: 16.0,
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

                  // Sign In button
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
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
                        signUp();
                        // Get.toNamed(Routes.HOMEPAGE);
                      },
                      icon: Icon(
                        Icons.login,
                        color: kblack,
                      ),
                      label: Text(
                        'Sign Up',
                        style: TextStyle(color: kblack, fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: Container(
                height: 70,
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
                        height: 30,
                        width: 40,
                      ),
                    ),
                    Text(
                      'SoundEmic',
                      style: TextStyle(
                          fontFamily: GoogleFonts.aclonica().fontFamily,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            if (authController.isLoading.value)
              Container(
                height: Get.height,
                width: Get.width,
                color: Colors.black.withOpacity(0.6),
              ),
            if (authController.isLoading.value)
              SafeArea(
                child: Container(
                  child: LinearProgressIndicator(
                    backgroundColor: kbackground1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
