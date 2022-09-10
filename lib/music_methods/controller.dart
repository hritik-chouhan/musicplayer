// SPDX-License-Identifier: Apache-2.0
import 'dart:async';
import 'dart:io';

import 'package:musicplayer/music_methods/mpd.dart';

class MPDTalker {
  String host;
  int port;
  // Socket socket;
  
  MPDTalker({
    this.host: "localhost",
    this.port: 6600,
    
    });

  /**
   * Send a request to MPD and get the output as a String.
   */
  Future<String> cmdStr(String cmd) {
    Completer<String> com = new Completer<String>();
    String data = "";
    
    // Connect to MPD.
    Socket.connect(host, port)
      .then((Socket socket) {
        // Write the command to MPD.
        socket.write("$cmd\n");
        
        // Listen for MPD.
        socket.listen((List<int> chars) {
          // Get the response.
          String line = new String.fromCharCodes(chars);
          data += line;
          
          // Check if MPD is done sending data.
          try {
            if(_atEnd(line)) {
              socket.close();
            }
          } catch(error, stacktrace) {
            com.completeError(error, stacktrace);
          }
        },
        onDone: () {
          // Finish the future if there hasn't been an error.
          if(!com.isCompleted) {
            com.complete(data);
          }
        });
      });
    
    return com.future;
  }
  
  /**
   * Check if MPD is done sending data.
   */
  bool _atEnd(String str) {

    //str.contains(new RegExp("ACK \[[0-9]?([0-9])@[0-9]?([0-9])\]"));
    if(str.contains("ACK [")) {
      for(String line in str.split("\n")) {
        if(line.startsWith("ACK [")) {
          throw new MPDError(line);
          break;
        }
      }
    }
    
    return str.endsWith("OK\n");
  }
  
  Future cmd(String str) {
    Completer com = new Completer();
    cmdStr(str).then((String data) {
      com.complete();
    });
    
    return com.future;
  }
  
  /**
   * Send a request to MPD and get the output as a List of Strings.
   */
  Future cmdList(String cmd) {
    Completer com = new Completer();
    
    // Get the data as a String, then turn it into a List.
    cmdStr(cmd).then((String dataStr) {
      List<String> data = [];
      
      // For each line in the string:
      for(String line in dataStr.split("\n")) {
        // It will be separated into key/value pairs.
        List<String> kv = line.split(":");
        
        // We care about the value in this case, so add it to our list.
        if(kv.length > 1)
          data.add(kv[1].trim());
      }
      
      // Finished.
      com.complete(data);
    });
    
    return com.future;
  }
  
  /**
   * Send a request to MPD and get the output as a Map of Strings keyed to Strings.
   */  
  Future<Map<String, String>> cmdMap(String cmd) async{
      Map<String, String> data = new Map<String, String>();

    
    // Get the data as a String, then turn it into a Map.
    String dataStr = await cmdStr(cmd);
      
      // For every line in the String:
      for(String line in dataStr.split("\n")) {
        // Split it into key value pairs like a map.
        List<String> kv = line.split(":");
        if(kv.length > 1) {
          // Add our keys/values to the map.
          data[kv[0].trim()] = kv[1].trim();
        }
      }
      
    
    
    return data;
  }
  
  /**
   * Send a request to MPD and get the output as a List of Maps of Strings keyed to Strings.
   * 
   * String newKey: The key that defines a new item in the list. 
   */
  Future<List<Map<String, String>>> cmdListMap(String cmd, {List<String>? newKeys}) async{
    Completer com = new Completer();
    
    // Set newKey's default to ["file"].
    if(newKeys == null)
      newKeys = ["file"];
      List<Map<String, String>> data = [];

    
    // Get the data as a String, then turn it into a List of Maps.
    

      String dataStr = await cmdStr(cmd);
      
      
      // For every line:
      for(String line in dataStr.split("\n")) {
        // Split it into keys/values.
        List<String> kv = line.split(":");
        if(kv.length > 1) {
          // If the key is a new key, create a new Map in our list.
          for(String key in newKeys) {
            if(kv[0].trim() == key) {
              data.add(Map<String, String>());
              break;
            }
          }
          // If we have Maps in our list, add the new item to the last Map.
          if(data.isNotEmpty) {
            data.last[kv[0].trim()] = kv[1].trim();
          }
        }
      }
    
    return data;

  }
}