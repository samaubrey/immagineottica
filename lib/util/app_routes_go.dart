import 'package:go_router/go_router.dart';
import 'package:immagineottica/schermate/griglia_occhiali/immagine_occhiale.dart';
import 'package:immagineottica/schermate/homepage/homepage.dart';
import 'package:immagineottica/schermate/login_page.dart';
import 'package:immagineottica/schermate/profilo/profilo_page.dart';
import 'package:immagineottica/schermate/spash_page.dart';
import 'package:immagineottica/schermate/tessera_lac/tessera_lac.dart';

final GoRouter routerGo = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const SplashPage()),
  GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  GoRoute(path: '/account', builder: (context, state) => const ProfiloPage()),
  GoRoute(path: '/homepage', builder: (context, state) => const Homepage()),
  GoRoute(path: '/tessera_lac', builder: (context, state) => const TesseraLac()),
], initialLocation: '/', debugLogDiagnostics: true,
  errorBuilder: (context, state) => const ProfiloPage());