import 'package:flutter/material.dart';

class ImmagineOcchiale extends StatelessWidget {
  const ImmagineOcchiale({Key? key, required this.immagine}) : super(key: key);
  final Image immagine;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: const Text('Profilo personale')),
        body: immagine,
    );
  }
}
