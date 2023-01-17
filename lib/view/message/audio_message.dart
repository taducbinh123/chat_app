import 'package:AMES/common/constant/path.dart';
import 'package:AMES/view/add_room_member/add_room_member_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:AMES/common/constant/ulti.dart';
import 'package:AMES/model/ChatMessage.dart';
import 'package:get/get.dart';

import '../../common/app_theme.dart';
import '../../controller/client_socket_controller.dart';
import '../../model/message.dart';

class AudioMessage extends StatefulWidget {
  final MessageModel message;
  final ClientSocketController clientSocketController = Get.find();
  AudioMessage({Key? key, required this.message}) : super(key: key);

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted) {
        setState(() {
          isPlaying = state == PlayerState.PLAYING;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      if(mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      if(mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    String url = "";
    if(clientSocketController.newAudioMessage.value){
      url = chatApiHost +
          "/api/chat/getFile/" + clientSocketController.messenger.chatList[0].FILE_PATH.toString();
      clientSocketController.newAudioMessage.value = false;
    }else{
      url = chatApiHost +
          "/api/chat/getFile/" +
          widget.message.FILE_PATH.toString();
    }
    print(url);
    audioPlayer.setUrl(url);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        // horizontal: kDefaultPadding * 0.9,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        color: widget.message.USER_UID == box.read("userUid")
            ? AppTheme.nearlyBlack
            : AppTheme.dark_grey.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topRight: (widget.message.USER_UID == box.read("userUid") &&
                  DateTime.parse(widget.message.SEND_DATE.toString())
                              .millisecondsSinceEpoch -
                          (widget.message.PRE_MSG_SEND_DATE.toString() == '0'
                              ? 0
                              : DateTime.parse(widget.message.PRE_MSG_SEND_DATE
                                      .toString())
                                  .millisecondsSinceEpoch) <=
                      2 * 60 * 1000
              ? Radius.circular(0)
              : Radius.circular(16)),
          topLeft: (widget.message.USER_UID != box.read("userUid") &&
                  DateTime.parse(widget.message.SEND_DATE.toString())
                              .millisecondsSinceEpoch -
                          (widget.message.PRE_MSG_SEND_DATE.toString() == '0'
                              ? 0
                              : DateTime.parse(widget.message.PRE_MSG_SEND_DATE
                                      .toString())
                                  .millisecondsSinceEpoch) <=
                      2 * 60 * 1000 && widget.message.PRE_USER_UID == widget.message.USER_UID
              ? Radius.circular(0)
              : Radius.circular(16)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 5),
              width: 35,
              child: FittedBox(
                fit: BoxFit.contain,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                    backgroundColor: MaterialStateProperty.all(
                        AppTheme.dark_grey), // <-- Button color
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed))
                        return AppTheme.dark_grey; // <-- Splash color
                    }),
                  ),
                ),
              )),
          Container(
            width: 80,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Slider(
                  min: 0,
                  activeColor: AppTheme.dark_grey,
                  max: duration.inMilliseconds.toDouble(),
                  value: position.inMilliseconds.toDouble(),
                  onChanged: (value) async {
                    print(value);
                    final position = Duration(milliseconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            width: 66,
            child: FittedBox(
              fit: BoxFit.contain,
              child: AutoSizeText(
                formatTime(position) + " | " + formatTime(duration),
                style: TextStyle(
                    fontSize: 12,
                    color: widget.message.USER_UID == box.read("userUid")
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
