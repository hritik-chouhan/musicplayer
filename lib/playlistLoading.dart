

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/musicPage.dart';

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
          
          // list = await mpdTalker.cmdListMap('playlistinfo');


          
          return MusicPageTest(list : list,);

//           SchedulerBinding.instance.addPostFrameCallback((_) {

//   // add your code here.

//   Navigator.push(
//         context,
//         new MaterialPageRoute(
//             builder: (context) => MusicPage()));
// });
//               WidgetsBinding.instance.addPostFrameCallback((_){
//                 Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MusicPage(),
//             ),
//           );


//   // Add Your Code here.

// });
          
          
          
        } else if(snapshot.data == null){
          return Text('no data');
    
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