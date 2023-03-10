import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({required String message,
Color backgroundColor = Colors.blue}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message),
  backgroundColor: backgroundColor));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

extension FileIsImmagine on FileObject {
  bool isImmagine(){
    String estensione = _ottieniEstensione();
    if (estensione == 'jpg' || estensione == 'jpeg' || estensione == 'png' ){
      return true;
    }
    else{
      return false;
    }
  }
  String _ottieniEstensione() {
    var indicePunto = name.lastIndexOf('.');
    return name.substring(++indicePunto);
  }
}

