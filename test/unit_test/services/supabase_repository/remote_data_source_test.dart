import 'package:immagineottica/services/supabase_repository/remote_data_source.dart';
import 'package:immagineottica/util/costanti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:immagineottica/util/database_exception.dart';

import '../../../supabase_flutter_misc.dart';

late final RemoteDataSourceImpl remoteDataSourceImpl;

void main()   {
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Supabase.initialize(
      url: "https://gnawtsxgzcnuovkyiaji.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZ"
          "SIsInJlZiI6ImduYXd0c3hnemNudW92a3lpYWppIiwicm9sZSI6ImFub24iLCJpYX"
          "QiOjE2NjE4NzgwNzAsImV4cCI6MTk3NzQ1NDA3MH0.Hl-EOIL1rd8LI-0A2as2o"
          "rwHh7EzVgHebZfECNUEoNA",
      localStorage: MockLocalStorage()
    );
    var risposta = await supabase.auth.signInWithPassword(email: 'samuelebiagianti@hotmail.it',
        password: 'password');
    remoteDataSourceImpl = RemoteDataSourceImpl();
  });





  group('Test per griglia di foto', () {
    test('prova a inizializzare la griglia di foto', () => _testGetGrigliaFoto());
    test('Ottieni tutti i file da Bucket ritorna i paths',
  () => _testOttieniTuttiFileDaBucketRitornaPaths());
  });

  group('Test per puntiLac', () {
    //test('Recupera i puntiLac dell\'utente', () => _testGetPuntiLac());
    test('Se il cliente non ha una tesseraLac e cerca di aprirla lancia'
  ' DatabaseException', () => _testNoTesseraLacLanciaEccezione());
    test('Dopo un primo accesso si viene reindirizzati alla pag /Profilo',
  () => _testAccessoEseguitoCorrettamente());
  });
}

_testAccessoEseguitoCorrettamente() {
  _utenteCorrenteIsSamuele();
}

_testGetPuntiLac() async {
  var risposta = await remoteDataSourceImpl.getPuntiLac();
  assert (risposta == 5);
}
_testNoTesseraLacLanciaEccezione() async {
  await expectLater(remoteDataSourceImpl.getPuntiLac(),
      throwsA(isA<DatabaseException>()));
}
_testGetGrigliaFoto() async {
  var risposta = await remoteDataSourceImpl.getTutteLeImmaginiComePath();
  assert (risposta.length >= 10);
}

_testOttieniTuttiFileDaBucketRitornaPaths() async {
  var risposta = await supabase.storage.from('avatars').list(path: 'avatars');
  for (var file in risposta) {
    assert(file.toString() != "" );
  }
  return;
}

_utenteCorrenteIsSamuele(){
  expect(supabase.auth.currentUser?.email, 'samuelebiagianti@hotmail.it');
  //print('Accesso eseguito correttamente come: ${supabase.auth.currentUser?.email}');
}