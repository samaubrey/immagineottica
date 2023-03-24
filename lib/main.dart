import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:immagineottica/app.dart';
import 'package:flutter/material.dart';
import 'package:immagineottica/util/no_connessione_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(!kIsWeb){
    final statoConnessione = await (Connectivity().checkConnectivity());
    if (statoConnessione != ConnectivityResult.mobile ||
  statoConnessione != ConnectivityResult.wifi){
      //todo: potrei provare una chiamata http per testare la conessione
      runApp(const NoConnessioneApp());
    }
  }
  await Supabase.initialize(
      url: "https://gnawtsxgzcnuovkyiaji.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZ"
          "SIsInJlZiI6ImduYXd0c3hnemNudW92a3lpYWppIiwicm9sZSI6ImFub24iLCJpYX"
          "QiOjE2NjE4NzgwNzAsImV4cCI6MTk3NzQ1NDA3MH0.Hl-EOIL1rd8LI-0A2as2o"
          "rwHh7EzVgHebZfECNUEoNA",
  );
  runApp(const ImmagineOtticaApp());
}

