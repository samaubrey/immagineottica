    import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:immagineottica/providers_di/immagine_ottica_navigazione.dart';
import 'package:immagineottica/schermate/profilo/widget/avatar.dart';
import 'package:immagineottica/util/barra_navigazione_basso.dart';
import '../../util/costanti.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({Key? key}) : super(key: key);

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  final _nomeController = TextEditingController();
  final _cognomeController = TextEditingController();
  String? _userId;
  String? _avatarUrl;
  bool _loading = false;

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });
    try {
      _userId = supabase.auth.currentUser!.id;
      final data = await supabase.from('profiles').select().eq('id', _userId)
    .single() as Map;
      _nomeController.text = (data['nome'] ?? '') as String;
      _cognomeController.text = (data['cognome'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    }
    on PostgrestException catch (error){
      switch (error.details){
        case ('Results contain 0 rows, '
            'application/vnd.pgrst.object+json requires 1 row') :
          context.showSnackBar(message: "Benvenuto."
              "\nInserisci il tuo Nome e Cognome e clicca su Aggiorna i dati");
          break;
        default:
          context.showErrorSnackBar(message: 'Si è verificato un errore '
              'in autetnticazione. Dettagli: ${error.toString()}');
      }
    }
    catch (error){
      context.showErrorSnackBar(message: 'Si è verificato un errore '
          'imprevisto. Dettagli: ${error.toString()}');
    }
    setState(() {
      _loading = false;
    });
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final nome = _nomeController.text;
    final cognome = _cognomeController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'nome': nome,
      'cognome': cognome,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        context.showSnackBar(message: 'Profilo aggiornato correttamente!');
        _getProfile();
      }
    }
    on PostgrestException catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore nell\''
    'aggiornamento dei dati.\nDettagli: ${error.message}');
    }
    catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore generico.'
          '\nDettagli: ${error.toString()}');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    }
    on AuthException catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore nella'
          'disconnessione.\nDettagli: ${error.message}');
    }
    catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore generico.'
          '\nDettagli: ${error.toString()}');
    }
    if (mounted){

      context.go('/');
    }
  }

  Future<void> _onUpload(String imageUrl) async {
    try {
      await supabase.from('profiles').upsert({'id': _userId,
    'avatar_url' : imageUrl });
      if (mounted){
        context.showSnackBar(
            message: 'La tua immagine del profilo è stata aggiornata!');
      }
    }
    on PostgrestException catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore nell\''
          'aggiornamento dell\'immagine.\nDettagli: ${error.message}');
    }
    catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore generico.'
          '\nDettagli: ${error.toString()}');
    }
    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState(){
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImmagineOtticaNavigazione tesseraLacSupabaseNavigazione =
  context.read();
    return Scaffold(
      appBar: AppBar(title: const Text('Profilo personale')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(
            imageUrl: _avatarUrl,
            onUpload: _onUpload,
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _navigateToHomepage,
              child: const Text('\nEntra nella App\n')),
          const SizedBox(height: 18),
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _cognomeController,
            decoration: const InputDecoration(labelText: 'Cognome'),
          ),

          const SizedBox(height: 18),
          ElevatedButton(onPressed: _updateProfile,
            child: Text(_loading ? 'Salvataggio in corso...' :
              'Aggiorna i dati')),
          ElevatedButton(onPressed: _signOut, child: const Text('Disconnettiti')),
        ],
      ),
      bottomNavigationBar: _profiloNonAncoraCreato() ? null :
    context.select<ImmagineOtticaNavigazione, BarraNavigazioneBasso>(
    (navigatore) => navigatore.barraNavigazioneBasso),
    );
  }

  void _navigateToHomepage() {
    final ImmagineOtticaNavigazione tesseraLacSupabaseNavigazione =
    context.read();
    if(_profiloNonAncoraCreato()) {
      context.showSnackBar(message: 'Inserire prima il nome e il cognome '
          'e premere \'Aggiorna i dati\'');
      return;
    }
    tesseraLacSupabaseNavigazione.setIndiceBarraNavigazioneBasso(0);
    context.go('/homepage');
  }
  bool _profiloNonAncoraCreato() {
    if (_nomeController.text == ''){
      return true;
    }
    return false;
  }

  @Deprecated('Solo per cambiarrea password manualmente un utente.'
'usa il campo cognome per inserire la nuova password')
  Future<void> _updatePassword() async {
    setState(() {
      _loading = true;
    });
    final password = _cognomeController.text;
    try {
      await supabase.auth.updateUser(UserAttributes(password: password));
      if (mounted) {
        context.showSnackBar(message: 'Profilo aggiornato correttamente!');
        _getProfile();
      }
    }
    on PostgrestException catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore nell\''
          'aggiornamento dei dati.\nDettagli: ${error.message}');
    }
    catch (error) {
      context.showErrorSnackBar(message: 'Si è verificato un errore generico.'
          '\nDettagli: ${error.toString()}');
    }
    setState(() {
      _loading = false;
    });
  }
}
