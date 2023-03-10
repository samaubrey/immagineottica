
import 'package:immagineottica/providers_di/immagine_ottica_navigazione.dart';
import 'package:immagineottica/providers_di/immagine_ottica_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immagineottica/util/barra_navigazione_basso.dart';
import 'package:immagineottica/util/costanti.dart';

class TesseraLac extends StatelessWidget {
  const TesseraLac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tesseraLacSupabaseState = context.watch<ImmagineOtticaState>();

    if (tesseraLacSupabaseState.immagineOtticaStateProcess ==
        ImmagineOtticaStateProcess.error) {
      return Scaffold(
          appBar: AppBar(title: const Text('La mia tessera Lenti a Contatto')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                  Text(tesseraLacSupabaseState.console,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
            const SizedBox(height: 25,),
            ElevatedButton(
                onPressed: () => tesseraLacSupabaseState.getTesseraLac(),
                child: const Text('Riprova'))
          ],
        ),
      ),
        bottomNavigationBar: context.select
        <ImmagineOtticaNavigazione, BarraNavigazioneBasso>(
                (navigatore) => navigatore.barraNavigazioneBasso),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('La mia tessera Lenti a Contatto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget> [
            if (tesseraLacSupabaseState.immagineOtticaStateProcess
                == ImmagineOtticaStateProcess.loading)
            const Center(
              child: CircularProgressIndicator(),
              ),

            if (tesseraLacSupabaseState.immagineOtticaStateProcess
                == ImmagineOtticaStateProcess.complete)
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: _disegnaTesseraLac(tesseraLacSupabaseState.puntiLac)
              ),
            ),
            const SizedBox(height: 25,),
            ElevatedButton(
                onPressed: () => tesseraLacSupabaseState.getTesseraLac(),
                child: const Text('Aggiorna la tua tessera'))
          ],
        ),
      ),
      bottomNavigationBar: context.select
      <ImmagineOtticaNavigazione, BarraNavigazioneBasso>(
              (navigatore) => navigatore.barraNavigazioneBasso),
    );
  }

  Widget _disegnaTesseraLac(int punti){
    switch (punti){
      case -1 : {
        return const Text('Non hai ancora una tessera',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        );
      }
      default : {
        return Text('I miei punti Lenti a Contatto:\n$punti',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        );
      }
    }
  }
}





