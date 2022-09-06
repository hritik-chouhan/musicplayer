import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoMusicFound extends StatelessWidget {
  const NoMusicFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(child: Center(child: Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*0.5,
          color: Colors.white,
          child: const Center(
            child: Text("NO MUSIC FILE FOUND IN THE MUSIC DIRECTORY!!!!", style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,

                    
            ),),
          ),
        ),)),
    );
  }
}