// SPDX-License-Identifier: Apache-2.0
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/size.dart';

class NoMusicFound extends StatefulWidget {
  const NoMusicFound({Key? key}) : super(key: key);

  @override
  State<NoMusicFound> createState() => _NoMusicFoundState();
}

class _NoMusicFoundState extends State<NoMusicFound> {
    double val = 0;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return  Scaffold(
      
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
                      child: Text("Title",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.fontsize/2,
                    
                    
                        ),),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text("duration",
                    style: TextStyle(color: Colors.white,fontSize: SizeConfig.fontsize*0.4),)),
                  ],)),

                  Flexible(
                    flex: 1,
                    child:Text("Artist",
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
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Empty Playlist",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Text("Please Add the music files in Media directory or Plug in USB drive",
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                )),
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
                      
                  child: Text("00:00")),
                  Flexible(
                    flex: 6,
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: Slider(
                        activeColor: Colors.blueGrey,
                        
                        thumbColor: Colors.transparent,
                        value: 0,
                        onChanged:(value){
                        
                      },
                      max: 1,
                      min: 0,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text("00:00")),
            
                   
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
                            elevation: 0,
                            badgeColor:  Colors.greenAccent,
                            child: IconButton(
                              icon: const Icon(Icons.loop),
                              color: Colors.greenAccent,
                               onPressed: (() {
                                  
                            }),),
                           ),

                            
              IconButton(onPressed: (){
            
              }, icon: Icon(Icons.skip_previous)),
              IconButton(
                onPressed: (){

              }, 
              icon: Icon(Icons.play_arrow)
              ),
              IconButton(onPressed: (){

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
                                    child: Slider(
                                      value: val,
                                       onChanged: (value){
                                        setState(() {
                                          val = value;
                                        });
                                      
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