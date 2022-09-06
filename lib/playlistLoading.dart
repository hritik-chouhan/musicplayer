

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/musicPage.dart';
import 'package:musicplayer/nomusic.dart';

import 'music_methods/controller.dart';

class PlaylistLoading extends StatelessWidget {
  PlaylistLoading({Key? key}) : super(key: key);


  

  @override

  MPDTalker mpdTalker = MPDTalker();
  List<Map<String, String>> playlist = [];



  String convertToMin(String str){
    String strforint = '';
    for(int i = 0; i<str.length;i++){
      if(str[i] == '.'){
        break;
      }
      strforint += str[i];
    }
    int num = int.parse(strforint);
    double min = num/60;
    double sec = num%60;
    String ans = min.toInt().toString()+'min ' + sec.toInt().toString()+'sec';
    return ans;

  }


  Future mymethod() async{
    playlist = await mpdTalker.cmdListMap('playlistinfo');
    return playlist;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: mymethod(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
    
                  if (snapshot.connectionState == ConnectionState.done) {
        // If we got an error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error} occurred',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
           
          // if we got our data
        } else if (snapshot.hasData) {
          // Extracting data from snapshot object
          List<Map<String, String>> list = snapshot.data as dynamic;

          if(list.isNotEmpty){

            mpdTalker.cmd('repeat 1');
          mpdTalker.cmd('single 0');
          mpdTalker.cmd('consume 0');
          mpdTalker.cmd('play');
          mpdTalker.cmd('pause 1');
          


          
          return MusicPageTest(list : list,);

          }
          else{
          return const NoMusicFound();

          }

          


          
          
          
        } else if(snapshot.data == null){
          return const NoMusicFound();
    
        }
        
      }
      return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
    
                 },
      ),
    );
    
  }
}