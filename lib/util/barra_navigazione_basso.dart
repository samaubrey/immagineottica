import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immagineottica/util/set_icone_icons.dart';

/*class BarraNavigazioneBasso extends BottomNavigationBar{
  BarraNavigazioneBasso({super.items = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.glasses),
        label: "Ultime novità"),
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.addressCard),
        label: "Tessera punti"),
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.person),
        label: "Profilo"),],
    required super.currentIndex ,
    selectedItemColor: Colors.blueAccent,
    onTap = _navigaConBottomBar,});

  int _selectedIndex = 0;

  void _navigaConBottomBar (int index) {
    _selectedIndex = index;
    switch (index) {
      case 0 : context.go('/homepage');
      break;
      case 1 : context.go('/tessera_lac');
      break;
      case 2 : context.go('/account');
      break;
    }
  }

} */

class BarraNavigazioneBasso extends StatelessWidget{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _navigaConBottomBar (int index) {
      selectedIndex = index;
      switch (index) {
        case 0 : context.go('/homepage');
        break;
        case 1 : context.go('/tessera_lac');
        break;
        case 2 : context.go('/account');
        break;
      }
    }

    print('>>>>>>>>>>>>Creata una BottomBar <<<<<<<<<<<<<<');
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(SetIcone.glasses),
            label: "Ultime novità"),
        BottomNavigationBarItem(icon: Icon(SetIcone.address_card),
            label: "Tessera punti"),
        BottomNavigationBarItem(icon: Icon(SetIcone.account_circle),
            label: "Profilo"),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: _navigaConBottomBar,);
  }
}


/*
Widget creaBottomAppBar() {
  print('>>>>>>>>>>>>Creata una BottomBar <<<<<<<<<<<<<<');
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.glasses),
          label: "Ultime novità"),
      BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.addressCard),
          label: "Tessera punti"),
      BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.person),
          label: "Profilo"),
    ],
    currentIndex: _selectedIndex,
    selectedItemColor: Colors.blueAccent,
    onTap: _navigaConBottomBar,);
}*/
