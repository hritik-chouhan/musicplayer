library MPD;

import "dart:async";
import "dart:io";




/**
 * An error for MPD.
 */
class MPDError extends Error {
  String msg;
  MPDError(this.msg) : super();
  
  String toString() {
    return "MPD Error: $msg";
  }
}