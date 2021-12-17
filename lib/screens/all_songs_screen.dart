import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music/screens/player_screen.dart';
import 'package:flutter_music/widgets/songs_loadwidget.dart';
import 'package:flutter_music/widgets/background_gradient.dart';
class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  _AllSongsScreenState createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {

  List<SongInfo> allsongs = [];

  @override
  void initState() {
    super.initState();
    setupAudio();
    print('..............................onBack...........................');
  }

  @override
  void dispose() {
    audioManagerInstance.release();
    super.dispose();
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
          if (index != allsongs.length - 1) {
            index++;
          } else {
            index = 0;
          }
          setState(() {
            currentSongIndex = index;
          });
          SongInfo song = allsongs[index];
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 5,
        backgroundColor: const Color(0xFF004e92),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Color(0xFF004e92),),
      ),
      body: Stack(
        children: [
          const BackgroundGradient(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<SongInfo>>(
                  future: FlutterAudioQuery()
                      .getSongs(sortType: SongSortType.RECENT_YEAR),
                  builder: (context, snapshot) {
                    allsongs = snapshot.data as List<SongInfo>;
                    if (snapshot.hasData) {
                      return SongWidget(songList: allsongs);
                    }
                    return SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Loading....",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(bottom: 10,left: 0,right: 0,child: isPlaying ? bottomPanel(allsongs) : const SizedBox(),)
        ],
      ),
    );
  }
  Widget bottomPanel(List<SongInfo> songs) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>PlayerScreen(songsList: allsongs))
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.9,
          margin: const EdgeInsets.all( 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
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
            color:    Color(0xFF004e92),
           /* gradient: LinearGradient(
                colors: [Color(0xff0a897f), Color(0xFF004e92)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),*/
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
                  Hero(
                    tag:'circleImage',
                    child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade700,
                        ),
                        child: const CircleAvatar(backgroundImage: AssetImage('assets/images/music.jpg'),)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        songs[currentSongIndex].title.isNotEmpty ? songs[currentSongIndex].title: '...',
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                              colors: [Color(0xff1c78db), Color(0xFF1c78db)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            isPlaying = await AudioManager.instance.playOrPause();
                          },
                          padding: const EdgeInsets.all(0.0),
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 48.0,
                            color: Colors.grey,
                          ),
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
        ),
      ),
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
    TextStyle style = const TextStyle(color: Colors.grey);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(audioManagerInstance.position),
          style: style,
        ),
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
        Text(
          _formatDuration(audioManagerInstance.duration),
          style: style,
        ),
      ],
    );
  }
}

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;
double _slider = 0.0;

