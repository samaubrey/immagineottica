import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:immagineottica/schermate/profilo/profilo_page.dart';
import 'package:immagineottica/services/supabase_repository/remote_data_source.dart';
import 'package:immagineottica/util/costanti.dart';

import '../supabase_flutter_misc.dart';

void main() {

  setUpAll(() async {
    await Supabase.initialize(
        url: "https://gnawtsxgzcnuovkyiaji.supabase.co",
        anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZ"
            "SIsInJlZiI6ImduYXd0c3hnemNudW92a3lpYWppIiwicm9sZSI6ImFub24iLCJpYX"
            "QiOjE2NjE4NzgwNzAsImV4cCI6MTk3NzQ1NDA3MH0.Hl-EOIL1rd8LI-0A2as2o"
            "rwHh7EzVgHebZfECNUEoNA",
        localStorage: MockLocalStorage()
    );
    var risposta = await supabase.auth.signInWithPassword(email: 'samuelebiagianti@hotmail.it',
        password: 'password');
  });

  testWidgets('Funzionamento di profilo_page al primo accesso',
(WidgetTester tester) async {
    await tester.pumpWidget(const ProfiloPage());
    expect(find.text('Samuele'), findsNothing);
  });
}