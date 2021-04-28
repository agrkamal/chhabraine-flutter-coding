import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rx<File> audioFile;
  RxBool isLoading = false.obs;
  RxInt totalSongs = 0.obs;
  int totalLikes;
  Rx<File> imageFile;

  AudioPlayer audioPlayer;
  RxBool isPlay = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    getSongsInfo();
    audioPlayer = AudioPlayer();
    // position.value = Duration(seconds: await audioPlayer.getCurrentPosition());
  }

  Future<void> refresh() async {
    await getSongsInfo();
  }

  Future<List<DocumentSnapshot>> getSongsInfo() async {
    QuerySnapshot snapshot;
    await _db
        .collection('songs')
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .get()
        .then((value) => snapshot = value);
    totalSongs.value = snapshot.docs.length;

    return snapshot.docs;
  }

  Stream<List<QueryDocumentSnapshot>> streamSongsInfo() {
    QuerySnapshot querySnapshot;
    totalLikes = 0;
    return _db
        .collection('songs')
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .orderBy('Date', descending: true)
        .snapshots()
        .map((event) {
      event.docs.forEach((element) {
        return element.data();
      });

      return event.docs;
    });
  }

  Future<void> updateName(String name) async {
    await _db
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'name': name});
  }

  updateImage() async {
    var imageUrl = '';

    if (imageFile != null) {
      Reference ref = _storage.ref(
          'images/${_auth.currentUser.uid}/${DateTime.now().toIso8601String()}.png');
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

    await _db.collection('users').doc(_auth.currentUser.uid).update({
      'photoUrl': imageUrl,
    });
  }

  uploadSong() async {
    isLoading.value = true;
    var audioUrl = '';
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowCompression: true,
        withReadStream: true,
      );

      final user = _auth.currentUser;
      if (result != null) {
        audioFile = File(result.files.single.path).obs;

        // printInfo(info: 'uri<<<<< ${audioFile.value.uri}');
        // printInfo(info: 'result>>>>> ${result.files.single.readStream.first.runtimeType }');

        if (audioFile != null) {
          Reference ref = _storage
              .ref('songs/${user.uid}/${DateTime.now().toIso8601String()}.mp3');
          var taskSnapshot = await ref.putFile(audioFile.value);
          if (taskSnapshot.state == TaskState.success) {
            await taskSnapshot.ref.getDownloadURL().then((url) async {
              audioUrl = url;
            }, onError: (e) {
              printError(info: 'Get image error $e');
            });
          } else {
            printInfo(info: 'Get image error ${taskSnapshot.state}');
          }
        }

        await _db.collection('songs').doc().set({
          'songUrl': audioUrl,
          'Date': DateTime.now(),
          'name': result.files.single.name,
          'size': result.files.single.size,
          'likes': 0,
          'uid': user.uid,
        });
        Get.snackbar('Song Uploaded', '');
      } else {
        Get.snackbar('No Song Picked', '');
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      printError(info: '$e');
      Get.snackbar('SomeThing Went Wrong', 'Please try later');
    }
  }

  play(String url) async {
    isPlay.value = true;
    await audioPlayer.play(url);
    Get.snackbar('Playing', '');
  }

  pause() async {
    isPlay.value = false;
    await audioPlayer.pause();
    Get.snackbar('Pause', '');
  }

  resume() async {
    isPlay.value = true;
    await audioPlayer.resume();
    Get.snackbar('Playing', '');
  }

  stop() async {
    isPlay.value = false;
    await audioPlayer.stop();
    Get.snackbar('Stoped', '');
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

    if (imageFile.value != null) {
      return imageFile.value;
    } else {
      return null;
    }
  }
}
