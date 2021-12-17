import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music/screens/all_songs_screen.dart';
import 'package:flutter_music/widgets/custom_app_bar.dart';
import 'package:flutter_music/widgets/songs_loadwidget.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatefulWidget {
  final List<SongInfo> songsList;

  const PlayerScreen({Key? key, required this.songsList}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

double _slider = 0.0;

class _PlayerScreenState extends State<PlayerScreen> {
  var controller=PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  void setupAudio() {
    audioManagerInstance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _slider = 0;
          break;
        case AudioManagerEvents.seekComplete:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          audioManagerInstance.updateLrc(args["position"].toString());
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          int index = currentSongIndex;
          if (index != widget.songsList.length - 1) {
            index++;
          } else {
            index = 0;
          }
          setState(() {
            currentSongIndex = index;
          });
          SongInfo song = widget.songsList[index];
          audioManagerInstance.start('file://${song.filePath}', song.title,
              desc: song.artist, cover: 'assets/images/icon.png');
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle style = const TextStyle(color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 5,
        backgroundColor: const Color(0xFF004e92),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Color(0xFF004e92),),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF004e92),
          Color(0xFF0C1674),
          Color(0xFF000428),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomAppBar(),
            Expanded(
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                children: [
                  const Pageone(),
                  PageTwo(list: widget.songsList)
                ],
              ),
            ),

            Container(
              height: 80,
              margin: const EdgeInsets.all(20),
              child: Marquee(
                text: audioManagerInstance.isPlaying &&
                        widget.songsList.isNotEmpty
                    ? widget.songsList[currentSongIndex].title
                    : ' ',
                style: const TextStyle(fontSize: 20, color: Colors.white),
                blankSpace: 90,
                velocity: -150,
                pauseAfterRound: const Duration(seconds: 3),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              height: size.height * 0.15,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: songProgress(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _formatDuration(audioManagerInstance.position),
                        style: style,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () {
                          int index = currentSongIndex;
                          if (index != 0) {
                            index--;
                          } else {
                            index = widget.songsList.length - 1;
                          }
                          currentSongIndex = index;

                          SongInfo song = widget.songsList[index];
                          audioManagerInstance.start(
                              'file://${song.filePath}', song.title,
                              desc: song.artist,
                              cover: 'assets/images/icon.png');
                          setState(() {});

                        },
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xff021421),
                                  offset: Offset(2, 3),
                                  spreadRadius: 2,
                                  blurRadius: 10),
                              BoxShadow(
                                  color: Color(0xff011221),
                                  offset: Offset(-3, -2),
                                  spreadRadius: -2,
                                  blurRadius: 20)
                            ],
                            color: const Color(0xFF004e92),
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 48.0,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            isPlaying =
                                await audioManagerInstance.playOrPause();
                          },
                          padding: const EdgeInsets.all(0.0),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          int index = currentSongIndex;
                          if (index != widget.songsList.length - 1) {
                            index++;
                          } else {
                            index = 0;
                          }
                          setState(() {
                            currentSongIndex = index;
                          });
                          SongInfo song = widget.songsList[index];
                          audioManagerInstance.start(
                              'file://${song.filePath}', song.title,
                              desc: song.artist,
                              cover: 'assets/images/icon.png');
                          setState(() {});
                        },
                      ),
                      Text(
                        _formatDuration(audioManagerInstance.duration),
                        style: style,
                      ),
                    ],
                  )
                ],
              ),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xff021421),
                        offset: Offset(2, 6),
                        spreadRadius: 2,
                        blurRadius: 10),
                    BoxShadow(
                        color: Color(0xff011221),
                        offset: Offset(-3, -5),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ],
                  color: const Color(0xFF004e92).withOpacity(0.5),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF141F8B),
                        Color(0xFF040C58),],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(onPressed: (){}, icon:const Icon(Icons.favorite,color: Colors.white,size: 30,),),
                        IconButton(onPressed: (){}, icon:const Icon(Icons.autorenew,color: Colors.white,size: 30,),),
                        IconButton(onPressed: (){}, icon:const Icon(Icons.volume_up,color: Colors.white,size: 30,),),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomPanel(List<SongInfo> songs) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF360603), Color(0xFF210908), Color(0xFF0d0504)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: songProgress(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  iconSize: 36,
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    int index = currentSongIndex;
                    if (index != 0) {
                      index--;
                    } else {
                      index = songs.length - 1;
                    }
                    setState(() {
                      currentSongIndex = index;
                    });
                    SongInfo song = songs[index];
                    audioManagerInstance.start(
                        'file://${song.filePath}', song.title,
                        desc: song.artist, cover: 'assets/images/icon.png');
                    setState(() {});
                  }),
              Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade700,
                  ),
                  child: const Icon(
                    Icons.audiotrack,
                    size: 32,
                    color: Colors.white,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    songs[currentSongIndex].title ?? '',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      isPlaying = await audioManagerInstance.playOrPause();
                    },
                    padding: const EdgeInsets.all(0.0),
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48.0,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                      iconSize: 36,
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        int index = currentSongIndex;
                        if (index != songs.length - 1) {
                          index++;
                        } else {
                          index = 0;
                        }
                        setState(() {
                          currentSongIndex = index;
                        });
                        SongInfo song = songs[index];
                        audioManagerInstance.start(
                            'file://${song.filePath}', song.title,
                            desc: song.artist, cover: 'assets/images/icon.png');
                        setState(() {});
                      }),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget songProgress(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Hero(
              tag: 'slider',
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbColor: Colors.blueAccent,
                    overlayColor: Colors.blue,
                    thumbShape: const RoundSliderThumbShape(
                      disabledThumbRadius: 5,
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                    activeTrackColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.grey,
                  ),
                  child: Slider(
                    value: _slider,
                    onChanged: (value) {
                      setState(() {
                        _slider = value;
                      });
                    },
                    onChangeEnd: (value) {
                      if (audioManagerInstance.duration != null) {
                        Duration msec = Duration(
                            milliseconds:
                                (audioManagerInstance.duration.inMilliseconds *
                                        value)
                                    .round());
                        audioManagerInstance.seekTo(msec);
                      }
                    },
                  )),
            ),
          ),
        ),
      ],
    );
  }


}

class Pageone extends StatelessWidget {
  const Pageone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:'circleImage',
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40,horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: Colors.blueAccent, width: 5)),
          child: Lottie.asset('assets/animations/rings.json',animate: audioManagerInstance.isPlaying)),
    );
  }
}
class PageTwo extends StatefulWidget {
  final List<SongInfo> list;
  const PageTwo({Key? key,required this.list}) : super(key: key);

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context,songIndex)
          {
            SongInfo song = widget.list[songIndex];
            if(song.displayName.contains(".mp3")) {
              return InkWell(
                onTap: (){
                  currentSongIndex=songIndex;
                  audioManagerInstance.start('file://${song.filePath}'
                      , song.title, cover: 'assets/images/icon.png', desc: 'desc');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width*.13,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF0C1674),
                              ),
                              child: const Icon(Icons.audiotrack,size: 32,color: Colors.white,)
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width*.6,
                                child: Text(song.title,style: const TextStyle(fontSize: 15,color: Colors.white,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w700),),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*.4,
                                child: Text("Artist ${song.artist}",style: const TextStyle(
                                    fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w500
                                ),overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          currentSongIndex==songIndex ? SizedBox(
                              width: MediaQuery.of(context).size.width*.13,
                              height: 55,
                              child: const Icon(Icons.bar_chart,size: 32,color: Colors.grey,)
                          ):const SizedBox(),
                        ],
                      ),
                    ),
                    const Divider(height: 0.1,thickness: 0.2,color: Colors.grey,)
                  ],
                ),
              );
            }
            return const SizedBox(height: 0,);
          }),
    );
  }
}


