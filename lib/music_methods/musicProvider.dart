
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/class.dart';
import 'package:musicplayer/music_methods/modeClass.dart';

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
    static final CurrentSong currentval = CurrentSong(title: 'title', artist: 'unknown', duration: '0min 0sec',isPlaying: false, time: '0');

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

final Modeprovider = StateNotifierProvider<mode,Mode>(((ref) => mode()));

class mode extends StateNotifier<Mode>{
    mode() : super(intial_value);
    static final Mode intial_value = Mode(isRepeat: true, isSingle : false, prev: true);
    
    void update({bool? isSingle, bool? isRepeat, bool? prev}){
        state = state.copyWith(isRepeat : isRepeat, isSingle : isSingle,prev: prev);
    }

}

final currIndexProvider = StateNotifierProvider<Index,int>(((ref) => Index()));

class Index extends StateNotifier<int>{
    Index() : super(0);
    
    void update(int val){
        state = val;
    }

}


