import 'package:flutter/material.dart';

abstract class LocalDataSource {
  Future<Image> getImmagine();
}

class LocalDataSourceImpl extends LocalDataSource{

  @override
  Future<Image> getImmagine() {
    // TODO: implement getImmagine
    throw UnimplementedError();
  }

}