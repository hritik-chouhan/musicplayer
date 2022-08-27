
import 'dart:core';

class CurrentSong{
  CurrentSong({required this.title, required this.artist, required this.duration, required this.isPlaying, required this.time});

  final String title;
  final String artist;
  final String duration;
  final bool isPlaying;
  final String time;

  CurrentSong copyWith({
    String ? title,
    String ? artist,
    String ? duration,
    bool ? isPlaying,
    String? time,
  }){
    return CurrentSong(artist: artist ?? this.artist,
     title: title ?? this.title,
     duration:  duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      time: time ?? this.time,
      );
  }

}