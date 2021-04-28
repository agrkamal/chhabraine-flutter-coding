import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomepageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // final ScrollController scrollController = ScrollController();

  Rx<int> selectedPageIndex = 0.obs;

  int documentLimit = 25;
  bool more = true;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    // scrollController.addListener(() {
    //   fetchSongs();
    // });
  }

  @override
  void onClose() {
    super.onClose();
    // scrollController.dispose();
  }

  Stream<List<QueryDocumentSnapshot>> fetchSongs({
    int limit,
    DocumentSnapshot startAfterSnapshot,
  }) {
    // return
    final refUser =
        _db.collection('songs').orderBy('Date', descending: true).limit(25);

    if (startAfterSnapshot == null) {
      return refUser.snapshots().map((event) {
        // printInfo(info: '${event.docs.toString()}');
        return event.docs;
      });
    } else {
      return refUser
          .startAfterDocument(startAfterSnapshot)
          .snapshots()
          .map((event) {
        // printInfo(info: '${event.docs.toString()}');
        return event.docs;
      });
    }
  }

  Future<int> likeSong(String docId) async {
    await _db
        .collection('songs')
        .doc(docId)
        .collection('likes')
        .doc()
        .set({'uid': _auth.currentUser.uid}).then((value) async {
      await _db
          .collection('songs')
          .doc(docId)
          .collection('likes')
          .get()
          .then((value) async {
        print(value.docs.length.toString());
        await _db.collection('songs').doc(docId).update({
          'likes': value.docs.length,
        });
      });
    });

    await _db
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('likedSong')
        .doc()
        .set({'songId': docId});
    return null;
  }
}
