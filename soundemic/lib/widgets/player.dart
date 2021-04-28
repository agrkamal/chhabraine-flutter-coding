import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soundemic/constant/colors.dart';
import 'package:soundemic/controller/profile_controller.dart';

class Player extends StatefulWidget {
  Player(this.name);
  final String name;
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final ProfileController profileController = Get.put(ProfileController());

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Song ${widget.name}',
            style:const  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              profileController.isPlay.value
                  ? profileController.pause()
                  : profileController.resume();
            },
            child: CircleAvatar(
              backgroundColor: kblack,
              child: Obx(
                () => Icon(
                  profileController.isPlay.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 38,
                ),
              ),
              radius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
