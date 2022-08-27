
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/class.dart';

final PositionProvider = StateNotifierProvider<Position,Duration>(((ref) => Position()));

class Position extends StateNotifier<Duration>{
    Position() : super(Duration(seconds: 0));
    void update(value) async{
        state = value;
    }


}

final CurrentSongProvider = StateNotifierProvider<Current, CurrentSong>(((ref) => Current()));

class Current extends StateNotifier<CurrentSong>{
    Current() : super(currentval);
    static final CurrentSong currentval = CurrentSong(title: 'title', artist: '', duration: '1min 20sec',isPlaying: false, time: '0');

    void update({ String? title,  String? artist,  String? duration,  bool? isPlaying, String? time}){
        state = state.copyWith(title: title, artist: artist, duration: duration, isPlaying: isPlaying,time: time);
    }

}

final VolumeProvider = StateNotifierProvider<Volume,int>(((ref) => Volume()));

class Volume extends StateNotifier<int>{
    Volume() : super(70);
    
    void update(int val){
        state = val;
    }

}

