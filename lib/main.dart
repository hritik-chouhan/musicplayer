import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/loadingPage.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:musicplayer/music_methods/controller.dart';
import 'package:musicplayer/music_methods/musicProvider.dart';
import 'package:musicplayer/music_methods/progress-bar.dart';


void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: loadingPage(),
    );
  }
}

class MusicPage extends ConsumerStatefulWidget {
  List<Map<String, String>> list;
  
  MusicPage({Key? key, required this.list}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}



class _MusicPageState extends ConsumerState<MusicPage> {


  MPDTalker mpdTalker = MPDTalker();
  bool isPlaying = false;
  int currindex = 1;
  String currSongTime = '0';
  late Timer timer;
  StreamController _streamController = StreamController();
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(CurrentSongProvider.notifier).update(artist:widget.list[1]['Artist'].toString(), title:widget.list[1]['file'].toString(),
     duration: convertToMin(widget.list[1]['duration'].toString()), time: '0');
     
     timer = Timer.periodic(Duration(seconds: 1), (timer) async{

      Map info = await mpdTalker.cmdMap('status');
      ref.read(CurrentSongProvider.notifier).update(time: info['time']);
      
      _streamController.sink.add(info['time']);


      });
     

    });
    
     


  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  

  

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
  String convertTosimpleStr(String str){
    String strforint = '';
    for(int i = 0; i<str.length;i++){
      if(str[i] == '.'){
        break;
      }
      strforint += str[i];
    }
    return strforint;

  }

  


 

  
  @override
  Widget build(BuildContext context) {
    isPlaying = ref.watch(CurrentSongProvider).isPlaying;
    currSongTime = ref.watch(CurrentSongProvider).time;
    
    // print(widget.list);
    

  
    


   
    print('hello');
    return Scaffold(
      
      body: Column(children: [
        // ElevatedButton(onPressed: (){

        //   mpdTalker.cmdStr('play');
        //   // print(data);

        // }, child: Text('play')),

        //  ElevatedButton(onPressed: (){

        //   mpdTalker.cmdStr('stop');
        //   // print(data);

        // }, child: Text('stop')),

        //  ElevatedButton(onPressed: (){

        //   mpdTalker.cmdStr('next');
        //   // print(data);

        // }, child: Text('next')),

        // ElevatedButton(onPressed: (){

        //   mpdTalker.cmdStr('previous');
        //   if(isPlaying == false){
        //         setState(() {
        //         isPlaying = !isPlaying;
        //       });

        //       }
          
        //   // print(data);

        // }, child: Text('previous')),
        ElevatedButton(onPressed: () async{

          Map info = await mpdTalker.cmdMap('status');
          print(info);
          print(info['duration']);
          
          
          
          // print(data);

        }, child: Text('info')),

        
        Row(
          children: [
            Container(
              height: 200,
              width: 200,
              child: Card(
                elevation: 5,
                color: Colors.blueGrey,
                child: ListTile(
                  title: Text(ref.watch(CurrentSongProvider).title),
                  subtitle: Text(ref.watch(CurrentSongProvider).artist),
                  trailing: Text(ref.watch(CurrentSongProvider).duration),
                ),
              ),
            ),
    //         FutureBuilder(
    //           future: mymethod(),
    //           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 

    //             if (snapshot.connectionState == ConnectionState.done) {
    //   // If we got an error
    //   if (snapshot.hasError) {
    //     return Center(
    //       child: Text(
    //         '${snapshot.error} occurred',
    //         style: TextStyle(fontSize: 18, color: Colors.black),
    //       ),
    //     );
         
    //     // if we got our data
    //   } else if (snapshot.hasData) {
    //     // Extracting data from snapshot object
    //     List<Map<String, String>> list = snapshot.data as dynamic;
        
    //     print(snapshot.data);
    //     return Text('');
    //   } else if(snapshot.data == null){
    //     return Text('no data');

    //   }
      
    // }
    // return Center(
    //           child: CircularProgressIndicator(
    //             color: Colors.black,
    //           ),
    //         );

    //            },
              
    //         ),
            Container(
                height: 200,
                width: 300,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.list.length,
                  itemBuilder: ((context, index) => ListTile(title: Text(widget.list[index]['file'].toString()),
                  subtitle: Text(widget.list[index]['Artist'] == null ? '' : widget.list[index]['Artist'].toString()),
                  trailing: Text(
                    convertToMin(widget.list[index]['duration'].toString()),
                  ),
                  onTap: (){
                    print(index);
                    ref.read(CurrentSongProvider.notifier).update(artist:widget.list[index]['Artist'].toString(), title: widget.list[index]['file'].toString(),
                 duration: convertToMin(widget.list[index]['duration'].toString(),) ,isPlaying: true,);
            
                    mpdTalker.cmdStr('playid ' +widget.list[index]['Id'].toString());
            
                    currindex = index;
            
                  },
                  ))),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){
              // mpdTalker.cmdStr('previous');
              mpdTalker.cmdStr('previous');
              ref.read(CurrentSongProvider.notifier).update(isPlaying: true);

              if(currindex == 0){
                  currindex = widget.list.length-1;

                  ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
     duration: convertToMin(widget.list[currindex]['duration'].toString(),));
              }
              else{
                currindex--;
                ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
     duration: convertToMin(widget.list[currindex]['duration'].toString(),));
              }
              
              

            }, icon: Icon(Icons.skip_previous)),
            IconButton(
              onPressed: (){

              if(isPlaying){
                mpdTalker.cmdStr('pause 1');
              }
              else{
                mpdTalker.cmdStr('pause 0');
              }
              ref.read(CurrentSongProvider.notifier).update( isPlaying: !isPlaying);
              


            }, 
            icon: isPlaying ? Icon(Icons.pause): Icon(Icons.play_arrow)
            ),
            IconButton(onPressed: (){

              mpdTalker.cmdStr('next');
              ref.read(CurrentSongProvider.notifier).update(isPlaying: true);

              if(currindex == widget.list.length-1){
                  currindex = 0;
              ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
     duration: convertToMin(widget.list[currindex]['duration'].toString(),));
              }
              else{
                currindex++;
                ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
     duration: convertToMin(widget.list[currindex]['duration'].toString(),));
              }
              

              

            }, icon: Icon(Icons.skip_next)),
          ],
        ),
        // StreamBuilder(
        //   stream: _streamController.stream,
        //   builder: ((context, snapshot){
        //     if(snapshot.hasData){
        //       print(snapshot.data);
        //       return Text(snapshot.data.toString());
        //     }
        //     if(snapshot.hasError){
        //       return Text('Error');
        //     }
        //     else{
        //       return Text('unknown');
        //     }
        //   }
        //   )
        //   ),
        
        // SizedBox(
        //   height: 50,
        //   width: 300,
        //   child: RotatedBox(quarterTurns: 1,
        //   child: ProgressBar())), bc


        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
          
            child: Text(convertToMin(currSongTime))),
            Flexible(
              flex: 6,
              child: RotatedBox(
                quarterTurns: 4,
                child: Slider(value: int.parse(currSongTime).toDouble()/(int.parse(convertTosimpleStr(widget.list[currindex]['duration'].toString())).toDouble()), 
                onChanged:(value){
                  print(value);
                  double seekTime = value*int.parse(convertTosimpleStr(widget.list[currindex]['duration'].toString())).toDouble();
                  int seektime = seekTime.toInt();
                  print(seektime);
                    mpdTalker.cmd('seekcur $seektime');
                },
                max: 1,
                min: 0,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(convertToMin(widget.list[currindex]['duration'].toString()))),

              Flexible(
                flex: 2,
                child: RotatedBox(
                        quarterTurns: 4,
                        child: Slider(value: ref.watch(VolumeProvider).toDouble()/100, onChanged: (Value){
                          double vol = Value*100;
                          int songVol = vol.toInt();
                          mpdTalker.cmd('setvol $songVol');
                          ref.read(VolumeProvider.notifier).update(songVol);
                      
                        }),
                      ),
              )
          ],
        ),
        

        
      ]),
    );

    
    
  }
}