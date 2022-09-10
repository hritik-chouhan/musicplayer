// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:musicplayer/size.dart';

import 'music_methods/controller.dart';
import 'music_methods/modeClass.dart';
import 'music_methods/musicProvider.dart';

class MusicPageTest extends ConsumerStatefulWidget {
  List<Map<String, String>> list;
  
  MusicPageTest({Key? key, required this.list}) : super(key: key);

  @override
  _MusicPageTestState createState() => _MusicPageTestState();
}



class _MusicPageTestState extends ConsumerState<MusicPageTest> {


  MPDTalker mpdTalker = MPDTalker();
  bool isPlaying = false;
  late int currindex;
  String currSongTime = '0';
  late Timer timer;

  late Mode mode;
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      ref.read(CurrentSongProvider.notifier).update(artist:widget.list[0]['Artist'].toString(), title:widget.list[0]['file'].toString(),
     duration: convertToMin(widget.list[0]['Time'].toString()), time: '0');

     //timer for progress bar
     
     timer = Timer.periodic(Duration(seconds: 1), (timer) async{

      Map info = await mpdTalker.cmdMap('status');
      ref.read(CurrentSongProvider.notifier).update(time: info['time']);

     


      if(int.parse(currSongTime) == int.parse(convertTosimpleStr(widget.list[currindex]['Time'].toString()))-1 && mode.isSingle == false){
              

             
              
            ref.read(CurrentSongProvider.notifier).update(isPlaying: true);
            
                if(currindex == widget.list.length-1){
                        currindex = 0;
                        ref.read(currIndexProvider.notifier).update(currindex);
                ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
                 duration: convertToMin(widget.list[currindex]['Time'].toString(),));
                }
                else{
                  currindex++;
                  ref.read(currIndexProvider.notifier).update(currindex);


                  ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
                 duration: convertToMin(widget.list[currindex]['Time'].toString(),));
                }
                


      }

       

      

            


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
    String ans = min.toInt().toString()+':' + sec.toInt().toString();
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
    SizeConfig().init(context);

    mode = ref.watch(Modeprovider);
    currindex = ref.watch(currIndexProvider);
    
    
    

  
    


   
    return Scaffold(
      
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Flexible(
            flex: 4,
            child: Flex(direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  
              height: SizeConfig.screenHeight*0.5,
              width: SizeConfig.screenWidth*0.4,
              // color: Colors.blueGrey,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 3,
                    child: Image.asset('assets/music.png')),
                  Flexible(
                    flex: 1,
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                  children: [Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(ref.watch(CurrentSongProvider).title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.fontsize/2,
                    
                    
                        ),),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(ref.watch(CurrentSongProvider).duration,
                    style: TextStyle(color: Colors.white,fontSize: SizeConfig.fontsize*0.4),)),
                  ],)),

                  Flexible(
                    flex: 1,
                    child:ref.watch(CurrentSongProvider).artist == 'null' ? const Text("Artist: unknown") : Text('Artist: ${ref.watch(CurrentSongProvider).artist}',
                    style: TextStyle(color: Colors.white,fontSize: SizeConfig.fontsize*0.4),),
                    )
                ],
                ),
              ),
              
            ),),
            Flexible(flex : 1,
            child: Container(
                height: SizeConfig.screenHeight*0.5,
                width: SizeConfig.screenWidth*0.4,
                child: ListView.builder(
                  controller: ScrollController(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.list.length,
                  itemBuilder: ((context, index) => Card(
                    color: Colors.blueGrey,
                    shadowColor: Colors.blueAccent,
                    elevation: 5,

                    child: ListTile(
                      minLeadingWidth: 4,
                      textColor: Color.fromARGB(199, 255, 255, 255),
                  
                      title: Text(widget.list[index]['file'].toString()),
                    subtitle: Text(widget.list[index]['Artist'] == null ? '' : widget.list[index]['Artist'].toString(),
                    style: TextStyle(color: Colors.black),),
                    trailing: Text(
                      convertToMin(widget.list[index]['Time'].toString(),),
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: (){
                  

                      ref.read(CurrentSongProvider.notifier).update(artist:widget.list[index]['Artist'] == null ? "Unknown": widget.list[index]['Artist'].toString(),
                       title: widget.list[index]['file'].toString(),
                                   duration: convertToMin(widget.list[index]['Time'].toString(),) ,isPlaying: true,);
                              
                      mpdTalker.cmdStr('playid ' +widget.list[index]['Id'].toString());
                              
                      currindex = index;
                  ref.read(currIndexProvider.notifier).update(currindex);
                      
                              
                    },
                    ),
                  ))),
              ),),
              

            ],
            )),
            Flexible(
              flex: 2,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                  Flexible(
                    flex: 1,
                      
                  child: Text(convertToMin(currSongTime))),
                  Flexible(
                    flex: 6,
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: Slider(
                        activeColor: Colors.blueGrey,
                        
                        thumbColor: Colors.transparent,
                        value: int.parse(currSongTime).toDouble()/((int.parse(convertTosimpleStr(widget.list[currindex]['Time'].toString())).toDouble())), 
                      onChanged:(value){
                        double seekTime = value*int.parse(convertTosimpleStr(widget.list[currindex]['Time'].toString())).toDouble();
                        int seektime = seekTime.toInt();
                          mpdTalker.cmd('seekcur $seektime');
                      },
                      max: 1,
                      min: 0,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(convertToMin(widget.list[currindex]['Time'].toString()))),
            
                   
                      ],
                    ),),
                    Flex(
                      direction: Axis.horizontal,

                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                          width: SizeConfig.screenWidth/3,
                        )),
                        Flexible(
                           flex : 1, 
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                           Badge(
                            badgeContent: mode.isSingle ? const Text('1') : null,
                            elevation: 0,
                            badgeColor:  Colors.greenAccent,
                            child: IconButton(
                              icon: const Icon(Icons.loop),
                              color: Colors.greenAccent,
                               onPressed: (() {
                                if(mode.isSingle){
                                  ref.read(Modeprovider.notifier).update(isSingle: false);
                                  mpdTalker.cmd('single 0');
                                }
                                if(mode.isSingle == false ){
                                        ref.read(Modeprovider.notifier).update(isSingle: true);
                                  mpdTalker.cmd('single 1');
                                  



                                }
                                

                              
                            }),),
                           ),

                            
              IconButton(onPressed: (){
                
                mpdTalker.cmdStr('previous');
                ref.read(CurrentSongProvider.notifier).update(isPlaying: true);
            
                if(currindex == 0){
                        
                        ref.read(currIndexProvider.notifier).update(widget.list.length-1);
                        currindex = widget.list.length-1;
            
                        ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
                 duration: convertToMin(widget.list[currindex]['Time'].toString(),));
                }
                else{
                  currindex--;
                  ref.read(currIndexProvider.notifier).update(currindex);
                  ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
                 duration: convertToMin(widget.list[currindex]['Time'].toString(),));
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
                  ref.read(currIndexProvider.notifier).update(0);

                       
                ref.read(CurrentSongProvider.notifier).update(artist:widget.list[0]['Artist'].toString(), title: widget.list[0]['file'].toString(),
                 duration: convertToMin(widget.list[0]['Time'].toString(),));
                }
                else{
                  currindex++;
                  ref.read(currIndexProvider.notifier).update(currindex);

                  ref.read(CurrentSongProvider.notifier).update(artist:widget.list[currindex]['Artist'].toString(), title: widget.list[currindex]['file'].toString(),
                 duration: convertToMin(widget.list[currindex]['Time'].toString(),));
                }
                
            
                
            
              }, icon: Icon(Icons.skip_next)),
             
              
                          ],
                        ),),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Icon(Icons.volume_up),
                              SizedBox(
                                width: SizeConfig.screenWidth/4,
                                child: RotatedBox(
                                    quarterTurns: 4,
                                    child: Slider(value: ref.watch(VolumeProvider).toDouble()/100, onChanged: (Value){
                                      double vol = Value*100;
                                      int songVol = vol.toInt();
                                      mpdTalker.cmd('setvol $songVol');
                                      ref.read(VolumeProvider.notifier).update(songVol);
                                      
                                    }),
                                  ),
                              ),
                            ],
                          ),

                        )
                      ],
                    ),
                ],
              ),
            ),
        
        ],
        


      ),
    );

    
    
  }
}