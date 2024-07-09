import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:melody/api/api.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:melody/api/url.dart';
import 'package:melody/util/log_util.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  var dataList = [];
  late AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  var idx = 0;

  getSongList() async {
    try {
      var dataListStr = await Api().get(Url.getList);
      List<dynamic> dataList = jsonDecode(dataListStr['Data']);

      setState(() {
        this.dataList = dataList;
      });
    } catch (e) {
       Fluttertoast.showToast(msg: e.toString());
    }
    
  }

  pauseMusic() async {
    await player.pause();
  }

  playMusic() async{
    await player.resume();
  }

  playDuration() async {
    var duration = await player.getDuration();
    logD(duration);
    await player.seek(Duration(seconds: 210));
  }

  playPrevMusic(index) async {
    await player.play(UrlSource('${Url.playMusic}?name=${dataList[index]['name']}',mimeType: 'mp3'));
    idx = index;
    setState(() { isPlaying = true; });
  }

  @override
  void initState() {
    super.initState();
    getSongList();

    player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (state == PlayerState.paused) {
        setState(() {
          isPlaying = false;
        });
      }
      else if (state == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  
    player.onPlayerComplete.listen((state) {
        idx = idx + 1;
        if (idx == dataList.length) {
          idx = 0 ;
        }
        playPrevMusic(idx);
    });

    // player.onDurationChanged.listen((duration) {
    //   logD(duration);
    // });

  }

    @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Melody'),
          backgroundColor: const Color.fromARGB(255, 21, 141, 210),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings page
                getSongList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (content, index) {
                  return InkWell(
                    onTap: () {
                      // playMusic(dataList[index]['name'],index);
                      playPrevMusic(index);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text((index + 1).toString()),
                            const SizedBox(width: 10),
                            Text(dataList[index]['name']),
                          ],
                        )),
                  );
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){ 
                      isPlaying ? pauseMusic() : playMusic();
                    }, child: isPlaying ? const Text('暂停') : const Text('播放') ),
                    // ElevatedButton(onPressed: (){
                    //   playDuration();
                    // }, child: const Text('快进'))
                   
                    // IconButton(
                    //     onPressed: () {
                    //       print('随机播放');
                    //     },
                    //     icon: const Icon(Icons.shuffle)),
                  ],
                ))
          ],
        ));
  }
}
