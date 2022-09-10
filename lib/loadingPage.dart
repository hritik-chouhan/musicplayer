// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:musicplayer/music_methods/controller.dart';
import 'package:musicplayer/nomusic.dart';
import 'package:musicplayer/playlistLoading.dart';
import 'package:musicplayer/socketProblem.dart';


class loadingPage extends ConsumerStatefulWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends ConsumerState<loadingPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  MPDTalker mpdTalker = MPDTalker();
  List<Map<String, String>> list = [];

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
    list = await mpdTalker.cmdListMap('listall');
    return list;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: mymethod(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
    
                  if (snapshot.connectionState == ConnectionState.done) {
        // If we got an error
        if (snapshot.hasError) {
          return const SocketProblem();
           
          // if we got our data
        } else if (snapshot.hasData) {
          // Extracting data from snapshot object
          List list = snapshot.data as dynamic;
          
          if(list.isNotEmpty){
            mpdTalker.cmdStr('clear');
          for(int i =0; i<list.length;i++){

            String addsong = list[i]['file'];
            
            mpdTalker.cmdStr('add "$addsong"');

          }
          return PlaylistLoading();

          }
          else{
          return NoMusicFound();
          }
        
        } else if(snapshot.data == null){
          return NoMusicFound();
    
        }
        
      }
      return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
    
                 },
      ),
    );
      

    
  }
}