import 'package:immagineottica/services/supabase_repository/supabase_repository.dart';
import 'package:immagineottica/util/database_exception.dart';
import 'package:immagineottica/util/storage_exception.dart';
import 'package:flutter/material.dart';

enum ImmagineOtticaStateProcess {loading, complete, error}

class ImmagineOtticaState extends ChangeNotifier{
  final SupabaseRepository supabaseRepository;
  var immagineOtticaStateProcess = ImmagineOtticaStateProcess.loading;
  int puntiLac = -1;
  String console = '';
  List<Image> listaImmagini = [
    const Image(image: AssetImage('immagini/biglietto_visita.jpg')),
    const Image(image: AssetImage('immagini/logo_immagine_ottica.jpg'))
  ];

  ImmagineOtticaState(this.supabaseRepository);

  Future<void> inizializzaDaDatabaseSupabase() async{
    await getTesseraLac();
    await getTutteLeImmagini();
  }

  Future<void> getTesseraLac() async{
    _impostaStateProcessSuLoading();
    await _provaRecuperareTesseraLac();
    notifyListeners();
  }
  Future<void> _provaRecuperareTesseraLac() async{
    try {
      puntiLac = await supabaseRepository.getPuntiLac();
      immagineOtticaStateProcess = ImmagineOtticaStateProcess.complete;
    }
    on DatabaseException catch (e){
      console = 'La tua tessera non è stata ancora creata, '
          'chiedi che venga fatto poi clicca su riprova. Grazie';
      //'Fallito il recupero dei punti della tua tessera Lac'
      //  ' da internet. Scrivici su Whatsapp per comunicarcelo, grazie.';
      immagineOtticaStateProcess = ImmagineOtticaStateProcess.error;
    }
    on Exception {
      _gestisciEccezioneGenerica();
    }
  }

  Future<void> getTutteLeImmagini() async {
    _impostaStateProcessSuLoading();
    await _provaRecuperareImmagini();
    notifyListeners();
  }
  Future<void> _provaRecuperareImmagini() async {
    try{
      var risposta = await supabaseRepository.getTutteLeImmaginiComePath();
      _popolaListaImmaginiComeImage(risposta);
      immagineOtticaStateProcess = ImmagineOtticaStateProcess.complete;
    }
    on StorageException catch (e) {
      immagineOtticaStateProcess = ImmagineOtticaStateProcess.error;
      console = e.messaggio;
    }
    on Exception {
      _gestisciEccezioneGenerica();
    }
  }
  @Deprecated("listaimmagini adesso è una List<Image>, non List<String>")
  void _popolaListaImmaginiComeString(List<String> risposta) {
    if(risposta.isNotEmpty){
      listaImmagini.clear();
      for (final path in risposta){
        //listaImmagini.add(path);
      }
      return;
    }
    throw StorageException("La lista di immagini ricevuta è vuota.");
  }
  void _popolaListaImmaginiComeImage(List<String> risposta) {
    if(risposta.isNotEmpty){
      listaImmagini.clear();
      for (final path in risposta){
        listaImmagini.add(Image.network(path));
      }
      return;
    }
    throw StorageException("La lista di immagini ricevuta è vuota.");
  }

  void _impostaStateProcessSuLoading() {
    immagineOtticaStateProcess = ImmagineOtticaStateProcess.loading;
    notifyListeners();
  }

  void _gestisciEccezioneGenerica() {
    console = 'Errore generico nel recupero dall\' archivio';
    immagineOtticaStateProcess = ImmagineOtticaStateProcess.error;
  }
}