import 'package:go_router/go_router.dart';
import '../screens/lista_screen.dart';
import '../screens/detalle_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) => const ListaScreen()
    ),
    GoRoute(
      path: '/detalle/:id',
      // Solo pasamos el ID como pide el requisito RF6
      builder: (context, state) => DetalleScreen(
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);