import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:soundemic/constant/routes.dart';
import 'package:soundemic/controller/homepage_controller.dart';
import 'package:soundemic/controller/profile_controller.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> signInformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpformKey = GlobalKey<FormState>();

  final Rx<bool> obsure = true.obs;
  final Rx<bool> pickFromGallery = true.obs;
  Rx<File> imageFile;
  RxBool isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    handleAuthState();
  }

  void handleAuthState() async {
    if (_auth.currentUser != null) {
      Get.toNamed(Routes.HOMEPAGE);
    } else {
      Get.toNamed(Routes.SIGNIN);
    }
  }

  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');
    if (_auth.currentUser.uid != null) {
      return _db.doc('/users/${_auth.currentUser.uid}').snapshots().map(
            (snapshot) => UserModel.fromMap(snapshot.data()),
          );
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    printInfo(info: '$email \n$password');
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailController.clear();
      passwordController.clear();
      handleAuthState();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', '${e.toString()}');
    }
  }

  Future<void> signUp(String email, String password) async {
    var imageUrl = '';
    try {
      // //Create New Account
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = _auth.currentUser;

      // Upload Image File to database if user picked an image
      if (imageFile != null) {
        Reference ref = _storage
            .ref('images/${user.uid}/${DateTime.now().toIso8601String()}.png');
        var taskSnapshot = await ref.putFile(imageFile.value);
        if (taskSnapshot.state == TaskState.success) {
          await taskSnapshot.ref.getDownloadURL().then((url) async {
            imageUrl = url;
          }, onError: (e) {
            printError(info: 'Get image error $e');
          });
        } else {
          printInfo(info: 'Get image error ${taskSnapshot.state}');
        }
      }

      // upload the data of the user to firestore
      UserModel newUser = UserModel(
        email: user.email,
        uid: user.uid,
        photoUrl: imageUrl,
      );

      await _db
          .collection('users')
          .doc(_auth.currentUser.uid)
          .set(newUser.toJson());

      handleAuthState();
      update();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      printInfo(info: 'Error ${e.toString()}');
      Get.snackbar('Something Went Wrong', 'Please Try later');
    }
  }

  void forgotPassword(String email) {
    try {
      print('email $email');
      if (email.length == 0) {
        Get.snackbar(
          'Enter Email Id',
          'Please Enter the registered Email ID',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _auth.sendPasswordResetEmail(email: email);
        Get.snackbar(
          'Email Sent on your registered email',
          'Please click on the link and enter the new Password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Something Went Wrong',
        'Please Try Later',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<File> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = File(pickedFile.path).obs;
    // = File(pickedFile.path);

    update();
    if (imageFile.value != null) {
      return imageFile.value;
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    ProfileController().dispose();
    HomepageController().dispose();
    Get.offAndToNamed(Routes.SIGNIN);
  }
}
