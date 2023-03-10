
import 'package:immagineottica/util/database_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../util/costanti.dart';

abstract class RemoteDataSource {
  Future<List<String>> getTutteLeImmaginiComePath();
  Future<int> getPuntiLac();
}

//Ora si chiama semplicemente Impl ma se dovessi usare qualcosa di diverso da
//supabase andrebbe chiamato RDSSupabase
class RemoteDataSourceImpl extends RemoteDataSource {

  String _bucket = 'avatars';
  final String userId = supabase.auth.currentUser!.id;

  @override
  Future<int> getPuntiLac() async {
    try {
      var puntiLac = await _getPuntiLacDaDatabasePrimaTessera();
      return puntiLac;
    }
    on PostgrestException catch (errore){
      throw DatabaseException('Si è verificato un errore nel recupero'
          ' dei tuoi punti.\nDettagli: ${errore.message}');
    }
    catch (errore){
      throw _seErroreGenericoRitornaComeDatabaseException(errore);
    }
  }
  Future<int> _getPuntiLacDaDatabasePrimaTessera() async {
    final risposta = await supabase.from('tessera_lac').select().
  eq("id_cliente", userId).single() as Map;
    return risposta['punti_lac'];
  }

  //todo: aggiungere metodo per get tutteImmaginiDaBucket
  @override
  Future<List<String>> getTutteLeImmaginiComePath() async {
    _bucket = 'nuovi-arrivi';
    try {
      final listaFile = await supabase.storage.from(_bucket).list();
      final urlFiles = _ottieniUrlPubbliciDelleImmagini(listaFile);
      if (urlFiles.isEmpty){
        throw const StorageException("Non è presente nessun file immagine"
      " nel bucket");
      }
      return urlFiles;
    }
    on PostgrestException catch (errore) {
      throw DatabaseException('Si è verificato un errore nel recupero delle '
    'immagini dal database.\n Dettagli: ${errore.message}');
    }
    catch (errore){
      throw _seErroreGenericoRitornaComeDatabaseException(errore);
    }
    finally {
      _bucket = 'avatar';
    }
  }
  List<String> _ottieniUrlPubbliciDelleImmagini(List<FileObject> listaFile) {
    var risposta = <String>[];
    for (var file in listaFile){
      if (file.isImmagine()){
        //Ottieni l'urlImmagine da supabase e aggiungila alla lista
        var urlImmagine = supabase.storage.from(_bucket).getPublicUrl(file.name);
        risposta.add(urlImmagine);
      }
    }
    return risposta;
  }

  DatabaseException _seErroreGenericoRitornaComeDatabaseException(Object errore) {
    return DatabaseException('Si è verificato un errore imprevisto.'
        '\nDettagli: ${errore.toString()}');
  }

}




