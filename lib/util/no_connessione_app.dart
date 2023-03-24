import 'package:flutter/material.dart';

class NoConnessioneApp extends StatelessWidget {
  const NoConnessioneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text('Sembra che tu non sia connesso ad internet. '
              'Connettiti e riprova.')
      ),
    );
  }
}
