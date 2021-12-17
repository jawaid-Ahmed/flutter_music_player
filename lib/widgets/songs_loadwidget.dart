
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music/screens/all_songs_screen.dart';

class SongWidget extends StatefulWidget {
  final List<SongInfo> songList;
  const SongWidget({required this.songList});


  @override
  State<SongWidget> createState() => _SongWidgetState();

  static String Parsetominsec(int ms){
    String data;
    Duration duration = Duration(milliseconds: ms);
    int min=duration.inMinutes;
    int sec = (duration.inSeconds)-(min*60);
    data= min.toString()+"0";
    if(sec<=9)data+="0";
    data+=sec.toString();
    return data;
  }


}
int currentSongIndex=0;

class _SongWidgetState extends State<SongWidget> {



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.songList.length,
        itemBuilder: (context,songIndex)
        {
          SongInfo song = widget.songList[songIndex];
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
        });
  }
}
