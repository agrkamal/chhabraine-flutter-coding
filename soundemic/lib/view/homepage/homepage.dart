import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soundemic/constant/colors.dart';
import 'package:soundemic/controller/auth_controller.dart';
import 'package:soundemic/controller/homepage_controller.dart';
import 'package:soundemic/controller/profile_controller.dart';
import 'package:soundemic/widgets/player.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final HomepageController homepageController = Get.put(HomepageController());
  final ProfileController profileController = Get.put(ProfileController());

  final ScrollController scrollController = ScrollController();

  Widget songsListTile(
    String songName,
    String date, {
    String likes,
    String url,
    IconData icon,
    String docId,
    bool liked,
  }) {
    return ListTile(
      title: Text(songName),
      subtitle: Text(date),
      leading: CircleAvatar(
        backgroundColor: kbackground2,
        child: IconButton(
          icon: Icon(
            icon,
            color: kblack,
            size: 30.0,
          ),
          onPressed: () async {
            await profileController.stop();
            Get.bottomSheet(
              bottomSheetWidget(
                Player(songName),
              ),
            );
            profileController.play(url);
          },
          padding: EdgeInsets.all(0.0),
        ),
      ),
      trailing: GestureDetector(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                homepageController.likeSong(docId);
              },
              icon: const Icon(
                Icons.favorite,
                size: 28,
              ),
              color: liked ? Colors.red : Colors.grey,
            ),
            Text('$likes'),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetWidget(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      height: Get.height * 0.8,
      width: Get.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://i.pinimg.com/736x/db/eb/d3/dbebd34af6b9f1b1927fadd085144568.jpg',
          ),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.asset(
              'assets/logo.jpg',
              height: 20,
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text('SoundEmic'),
        automaticallyImplyLeading: false,
        backgroundColor: kbackground2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                  'http://clipart-library.com/data_images/98591.png',
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title(
                color: kblack,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'SONGS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: homepageController.fetchSongs(
                      limit: homepageController.documentLimit,
                    ),
                    builder: (context, snapshot) {
                      // if (snapshot.hasData) {
                      //   if (snapshot.data.length <
                      //       homepageController.documentLimit) {
                      //     homepageController.more = false;
                      //   }
                      // }
                      // if (scrollController.offset >=
                      //     scrollController.initialScrollOffset) {
                      //   if (homepageController.more) {
                      //     homepageController.fetchSongs(
                      //       limit: homepageController.documentLimit,
                      //       startAfterSnapshot: snapshot.data.isNotEmpty
                      //           ? snapshot.data.last
                      //           : null,
                      //     );
                      //   }
                      // }
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Stack(
                              children: [
                                Container(
                                  color: Colors.white,
                                ),
                                LinearProgressIndicator(
                                  backgroundColor: kwhite,
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, i) {
                                return Container(
                                  child: Column(
                                    children: [
                                      songsListTile(
                                        snapshot.data[i]['name'],
                                        '${DateFormat().add_yMMMEd().format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data[i]['Date'].microsecondsSinceEpoch))}',
                                        icon: Icons.play_arrow_rounded,
                                        likes: snapshot.data[i]['likes']
                                            .toString(),
                                        url: snapshot.data[i]['songUrl']
                                            .toString(),
                                        docId: snapshot.data[i].id,
                                        liked: true,
                                      ),
                                      Divider(color: kblack.withOpacity(0.5)),
                                    ],
                                  ),
                                );
                              },
                            );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
