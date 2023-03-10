import 'dart:io';

class DatabaseException extends IOException{
  final String messaggio;

  DatabaseException(this.messaggio);
}