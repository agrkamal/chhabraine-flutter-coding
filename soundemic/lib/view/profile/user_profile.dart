import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:soundemic/constant/cliper.dart';
import 'package:soundemic/constant/colors.dart';
import 'package:soundemic/controller/profile_controller.dart';
import 'package:soundemic/models/user.dart';
import 'package:soundemic/widgets/player.dart';
import '../../controller/auth_controller.dart';

class UserProfile extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final ProfileController profileController = Get.put(ProfileController());

  int totalLikes = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kbackground1,
    ));
    return Obx(
      () => Stack(
        children: [
          RefreshIndicator(
            onRefresh: profileController.refresh,
            child: StreamBuilder(
                stream: profileController.streamSongsInfo(),
                builder: (context, sSnapshot) {
                  try {
                    totalLikes = 0;
                    for (var i = 0; i < sSnapshot.data.length; i++) {
                      totalLikes +=
                          int.parse(sSnapshot.data[i]['likes'].toString());
                    }
                  } catch (e) {
                    printInfo(info: e.toString());
                  }
                  return sSnapshot.connectionState == ConnectionState.waiting
                      ? LinearProgressIndicator()
                      : ListView(
                          children: [
                            StreamBuilder<UserModel>(
                                stream: authController.streamFirestoreUser(),
                                builder: (context, snapshot) {
                                  return snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: LinearProgressIndicator(),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                ClipPath(
                                                  clipper: ProfileCliper(),
                                                  child: Image(
                                                    height: 300,
                                                    width: double.infinity,
                                                    image: NetworkImage(
                                                        'https://image.freepik.com/free-vector/music-background-with-piano-keys_41770-148.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 5.0,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .white60,
                                                                offset: Offset(
                                                                    0, 2),
                                                                blurRadius: 6.0,
                                                              ),
                                                            ]),
                                                        child: ClipOval(
                                                          child: Image(
                                                            height: 140,
                                                            width: 140,
                                                            image: NetworkImage(
                                                                snapshot.data
                                                                    .photoUrl),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0.0,
                                                        right: 0.0,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              kwhite,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color: kblack,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await profileController
                                                                  .pickImage();
                                                              profileController
                                                                  .updateImage();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: Get.height * 0.05,
                                                    width: Get.width * 0.4,
                                                    child: Text(
                                                      snapshot.data.name == ''
                                                          ? 'Name'
                                                          : snapshot.data.name,
                                                      style: TextStyle(
                                                        fontSize: 25.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 5,
                                                    right: 10,
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                      ),
                                                      onTap: () async {
                                                        Get.bottomSheet(
                                                          bottomSheetWidget(
                                                              ListView(
                                                            children: [
                                                              Center(
                                                                child: Title(
                                                                  color: kblack,
                                                                  child: Text(
                                                                    'Edit Name',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      profileController
                                                                          .nameController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .name,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Name',
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        gapPadding:
                                                                            10.0,
                                                                        borderSide:
                                                                            BorderSide(width: 3.0)),
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value
                                                                            .isEmpty ||
                                                                        value ==
                                                                            null ||
                                                                        value.length <
                                                                            2) {
                                                                      return 'Enter Your Name';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await profileController
                                                                      .updateName(profileController
                                                                          .nameController
                                                                          .text)
                                                                      .then(
                                                                          (value) {
                                                                    Get.back();
                                                                    profileController
                                                                        .nameController
                                                                        .clear();
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'UPDATE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color:
                                                                        kblack,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Likes',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 22.0),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: Colors.red,
                                                          size: 24.0,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Text(
                                                      totalLikes.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Songs',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 22.0),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Icon(
                                                          Icons.music_note,
                                                          color:
                                                              Colors.blue[900],
                                                          size: 24.0,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Obx(
                                                      () => Text(
                                                        '${profileController.totalSongs.value}',
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 50.0),
                                            Container(
                                              height: Get.height * 0.6,
                                              // decoration: BoxDecoration(
                                              //     border:
                                              //         Border.all(color: Colors.red)),
                                              child: ListView.builder(
                                                itemCount:
                                                    sSnapshot.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return songsListTile(
                                                      '${sSnapshot.data[i]['name']}',
                                                      '${DateFormat().add_yMMMEd().format(DateTime.fromMicrosecondsSinceEpoch(sSnapshot.data[i]['Date'].microsecondsSinceEpoch))}',
                                                      likes: sSnapshot.data[i]
                                                              ['likes']
                                                          .toString(),
                                                      url: sSnapshot.data[i]
                                                          ['songUrl'],
                                                      icon: Icons
                                                          .play_arrow_rounded);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                }),
                          ],
                        );
                }),
          ),
          if (profileController.isLoading.value)
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black.withOpacity(0.6),
            ),
          if (profileController.isLoading.value)
            SafeArea(
              child: Container(
                child: LinearProgressIndicator(
                  backgroundColor: kbackground1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget bottomSheetWidget(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      height: Get.height * 0.8,
      width: Get.width,
      decoration: BoxDecoration(
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

  Widget songsListTile(String songName, String date,
      {String likes, String url, IconData icon}) {
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 28,
          ),
          Text('$likes'),
        ],
      ),
    );
  }
}
