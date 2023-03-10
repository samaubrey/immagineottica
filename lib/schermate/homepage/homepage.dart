
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immagineottica/providers_di/immagine_ottica_navigazione.dart';
import 'package:immagineottica/providers_di/immagine_ottica_state.dart';
import 'package:immagineottica/schermate/griglia_occhiali/griglia_foto.dart';
import 'package:immagineottica/util/barra_navigazione_basso.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    final tesseraLacSupabaseState = context.watch<ImmagineOtticaState>();

    if (tesseraLacSupabaseState.immagineOtticaStateProcess ==
        ImmagineOtticaStateProcess.error) {
      return Center(
          child: Text('Si è verificato un errore imprevisto.'
              '\nDettagli: ${tesseraLacSupabaseState.console}')
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Immagine Ottica per te')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tesseraLacSupabaseState.immagineOtticaStateProcess
          == ImmagineOtticaStateProcess.loading)
              const Center(child: CircularProgressIndicator() ),
            if (tesseraLacSupabaseState.immagineOtticaStateProcess
          == ImmagineOtticaStateProcess.complete)
              const GrigliaFoto()
          ],
        ),
        bottomNavigationBar: context.select
      <ImmagineOtticaNavigazione, BarraNavigazioneBasso>(
      (navigatore) => navigatore.barraNavigazioneBasso ),
    );
  }
}
