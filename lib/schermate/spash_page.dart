import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immagineottica/util/costanti.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool _redirectCalled = false;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted){
      return;
    }
    _redirectCalled = true;
    final session = supabase.auth.currentSession;
    if (session != null) {
      context.go('/homepage');
    }
    else{
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
