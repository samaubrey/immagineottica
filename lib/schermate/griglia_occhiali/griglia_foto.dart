import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immagineottica/providers_di/immagine_ottica_state.dart';
import 'package:immagineottica/util/costanti.dart';

class GrigliaFoto extends StatelessWidget {
  const GrigliaFoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tesseraLacSupabaseState = context.watch<ImmagineOtticaState>();

    return SizedBox(height: (MediaQuery
        .of(context)
        .size
        .height - 140),
      child: GridView.count(crossAxisCount: 2,
          children: List.generate(tesseraLacSupabaseState.listaImmagini.length,
                  (index) =>
                  InkWell(
                    //todo: onTap: () => context.showSnackBar(message: 'Cliccata l\'immagine ${tesseraLacSupabaseState.listaImmagini[index]}'),
                    child: tesseraLacSupabaseState.listaImmagini[index],
                  )
          )
      ),
      //children: tesseraLacSupabaseState.listaImmagini,),
    );
  }

  _navigaAImmagine(Image immagine, BuildContext context){
    context.showSnackBar(message: 'Cliccata la immagine: $immagine');
  }
}
