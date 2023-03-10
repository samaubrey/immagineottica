import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immagineottica/util/barra_navigazione_basso.dart';

class ImmagineOtticaNavigazione extends ChangeNotifier{

  final barraNavigazioneBasso = BarraNavigazioneBasso();

  void setIndiceBarraNavigazioneBasso(int indice){
    barraNavigazioneBasso.selectedIndex = indice;
  }
}