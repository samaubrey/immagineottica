import 'dart:io';

class StorageException extends IOException{
  final String messaggio;

  StorageException(this.messaggio);
}