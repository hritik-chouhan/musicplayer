

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'music_methods/controller.dart';
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
  int currindex = 1;
  String currSongTime = '0';
  late Timer timer;
  


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
            ),),
            Flexible(flex : 1,
            child: Container(
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
              ),),
              ElevatedButton(onPressed: () async{
                 List mylist1 = await mpdTalker.cmdListMap('listall');
                 String adddsong = mylist1[0]['file'];
                 mpdTalker.cmdStr('add $adddsong');
                 print(adddsong);
                 print(mylist1);

                //  List mylist = await mpdTalker.cmdListMap('list ');
                //  print(mylist);


                //  mpdTalker.cmd('find $adddsong');
                
                //  print(mylist);

              }, child: Text('database info')),

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
                    ),),
                    Flexible( flex : 1, child:  Row(
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
                    ),),
                ],
              ),
            ),
        
        ],
        


      ),
    );

    
    
  }
}