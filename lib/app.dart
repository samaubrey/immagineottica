
import 'package:immagineottica/providers_di/immagine_ottica_navigazione.dart';
import 'package:immagineottica/providers_di/immagine_ottica_state.dart';
import 'package:immagineottica/services/supabase_repository/local_data_source.dart';
import 'package:immagineottica/services/supabase_repository/remote_data_source.dart';
import 'package:immagineottica/services/supabase_repository/supabase_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immagineottica/util/app_routes_go.dart';
import 'package:immagineottica/util/no_transition_on_web.dart';

class ImmagineOtticaApp extends StatelessWidget {
  const ImmagineOtticaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = routerGo;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ImmagineOtticaState>(
        create: (context) => ImmagineOtticaState(SupabaseRepositoryImpl(
        LocalDataSourceImpl(),RemoteDataSourceImpl()))..inizializzaDaDatabaseSupabase()),
          ChangeNotifierProvider<ImmagineOtticaNavigazione>(
        create: (context) => ImmagineOtticaNavigazione())
        ],
        child: MaterialApp.router(
          title: 'Immagine Ottica per te',

          theme: ThemeData.light().copyWith(
            pageTransitionsTheme: NoTransitionsOnWeb(),
            primaryColor: Colors.green.shade800,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade300,
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.green.shade800,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
          ),
          routerConfig: router,
        ),
    );
  }
}