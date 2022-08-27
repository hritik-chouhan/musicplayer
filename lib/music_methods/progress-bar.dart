
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/class.dart';
import 'package:musicplayer/music_methods/musicProvider.dart';

class ProgressBar extends ConsumerStatefulWidget {
  
  const ProgressBar({Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<ProgressBar> {

    int StringToDouble(String str){
      String  min = "";
      String sec = "";
      for(int i = 0; i<str.length;i++){
          min += str[i];
          if(str[i] == 'm'){
            i++;
            while(str[i] != ' '){
              i++;
            }
            i++;
            while(i < str.length){
                sec += str[i];
            }
          }

      };
      int minu = int.parse(min);
      int seco = int.parse(sec);
      int total = minu*60 + seco;
      return total;
    }

  @override
  Widget build(BuildContext context) {
    CurrentSong currSong = ref.watch(CurrentSongProvider);
    
    return Slider(
      inactiveColor: Colors.blueGrey,
      value: 0, 
      onChanged:(Value){
        
      },
      max: StringToDouble(currSong.duration).toDouble()/500,
       );
    
  }
}