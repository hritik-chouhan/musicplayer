import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SocketProblem extends StatelessWidget {
  const SocketProblem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(child: Center(child: Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*0.5,
          color: Colors.white,
          child: const Center(
            child: Text("Unable to Connect with MPD server", style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,

                    
            ),),
          ),
        ),)),
    );
    
  }
}