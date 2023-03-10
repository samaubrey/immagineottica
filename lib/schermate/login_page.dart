import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:immagineottica/providers_di/immagine_ottica_navigazione.dart';
import 'package:immagineottica/util/costanti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/src/types/provider.dart' as gotrue;
import 'package:immagineottica/util/set_icone_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    final ImmagineOtticaNavigazione tesseraLacSupabaseNavigazione = context.read();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) {
        return;
      }
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        tesseraLacSupabaseNavigazione.setIndiceBarraNavigazioneBasso(2);
        context.go('/account');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Immagine Ottica")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text("Benvenuta/o Registrati",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 18,),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 18,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ElevatedButton(
                  onPressed: _isLoading ? null : _provaSignInConPassword,
                  child: Text(_isLoading ? "Caricamento" : "Accedi")),
              ElevatedButton(onPressed: _isLoading ? null : _provaSignUpWithPassword,
                  child: Text(_isLoading ? "Caricamento" : "Registrati\n"
                      " per il  primo accesso", textAlign: TextAlign.center,))
            ],),
          const SizedBox(height: 15,),
          ElevatedButton(onPressed: _provaSignInConMagicLink, child: Text('Accedi senza password'),
          ),
          const SizedBox(height: 30,),
          const Text("Accedi con:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(iconSize: 35,
            onPressed: _isLoading ? null : _provaSignInConFacebook,
                icon: const Icon(SetIcone.facebook_f),),
            IconButton(iconSize: 35,
            onPressed: _isLoading ? null : _provaSignInConGoogle,
              icon: const Icon(SetIcone.google),),
              ],)
        ],
      ),
    );
  }

  Future<void> _provaSignInConPassword() async {
    setState(() {
      _isLoading = true;
    });
    try{
      await _signInConPassword();
      if (mounted){
        final utenteCorrente = supabase.auth.currentUser;
        print("Accesso eseguito correttamente come: ${utenteCorrente?.email}");
        _emailController.clear();
        _passwordController.clear();
      }
    }
    on AuthException catch (error){
      switch (error.message){
        case 'Invalid login credentials' : context.showErrorSnackBar(
            message: 'Password o email sbagliata. Riprova.\n'
            'Dettagli: ${error.message}');
      }
      context.showErrorSnackBar(message: 'Si è verificato un errore in '
          'autenticazione.\nDettagli: ${error.message}');
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore imprevisto.\n'
          'Dettagli: ${error.toString()}');
    }
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _signInConPassword() async {
    final AuthResponse risposta = await supabase.auth.signInWithPassword(
  email: _emailController.text, password: _passwordController.text);
    print(risposta.user?.email);
}

  Future<void> _provaSignUpWithPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _signUpWithPassword();
      if (mounted){
        context.showSnackBar(message: 'Apri l\'email che ti è stata inviata');
        _emailController.clear();
        _passwordController.clear();
      }
    }
    on AuthException catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore in '
          'autenticazione. Dettagli: ${error.message}');
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore imprevisto.'
          'Dettagli: ${error.toString()}');
    }
    setState(() {
      _isLoading = false  ;
    });
  }
  Future<void> _signUpWithPassword() async {
    final AuthResponse risposta = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        emailRedirectTo: kIsWeb ? 'https://immagineottica.hopto.org:1911/webapp/' :
        'io.supabase.clienttesseralac://login-callback/'
    );
  }

  Future<void> _provaSignInConMagicLink() async {
    setState(() {
      _isLoading = true;
    });
    try{
      await _signInConMagicLink();
      if (mounted){
        context.showSnackBar(message: 'Apri l\'email che ti è stata inviata');
        _emailController.clear();
        _passwordController.text = 'Apri l\'email che ti è stata inviata';
      }
    }
    on AuthException catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore in '
          'autenticazione. Dettagli: ${error.message}');
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore imprevisto.'
          'Dettagli: ${error.toString()}');
    }
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _signInConMagicLink() async{
    await supabase.auth.signInWithOtp(email: _emailController.text,
        emailRedirectTo: kIsWeb ? 'https://immagineottica.hopto.org:1911/webapp/' :
        'io.supabase.clienttesseralac://login-callback/');
  }

  Future<void> _provaSignInConFacebook() async {
    setState(() {
      _isLoading = true;
    });
    try{
      await _singInConFacebook();
      if (mounted){
        context.showSnackBar(message: 'Accesso eseguito');
        _emailController.clear();
        _passwordController.clear();
      }
    }
    on AuthException catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore in '
          'autenticazione. Dettagli: ${error.message}');
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore imprevisto.'
          'Dettagli: ${error.toString()}');
    }
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _singInConFacebook() async{
    final response = await supabase.auth.signInWithOAuth(gotrue.Provider.facebook,
        redirectTo: kIsWeb ? 'https://immagineottica.hopto.org:1911/webapp/' :
        'io.supabase.clienttesseralac://login-callback/');
  }

  Future<void> _provaSignInConGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try{
      await _signInConGoogle();
      if (mounted){
        context.showSnackBar(message: 'Accesso eseguito.');
        _emailController.clear();
        _passwordController.clear();
      }
    }
    on AuthException catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore in '
          'autenticazione. Dettagli: ${error.message}');
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore imprevisto.'
          'Dettagli: ${error.toString()}');
    }
    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _signInConGoogle() async{
    final response = await supabase.auth.signInWithOAuth(gotrue.Provider.google,
        redirectTo: kIsWeb ? 'https://immagineottica.hopto.org:1911/webapp/' :
        'io.supabase.clienttesseralac://login-callback/');
  }


}
