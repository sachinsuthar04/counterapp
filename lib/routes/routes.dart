import 'package:counterapp/modules/bloc/counter/counter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../modules/bloc/success/success_bloc.dart';
import '../modules/data/repository/counter_repo.dart';
import '../modules/ui/pages/counter_screen.dart';

class DynamicRoutes {
  final String name;
  final String path;

  static final startPage = DynamicRoutes(
    name: 'Start',
    path: '/',
  );

  static final home = DynamicRoutes(
    name: 'Home',
    path: '/home',
  );

  DynamicRoutes({
    required this.name,
    required this.path,
  });

  static final router = GoRouter(
    restorationScopeId: "counter",
    routes: <RouteBase>[
      _start(),
      _home(),
    ],
  );

  static GoRoute _start() {
    return GoRoute(
      name: startPage.name,
      path: startPage.path,
      redirect: (context, state) {
        return DynamicRoutes.home.path;
      },
    );
  }

  static GoRoute _home() {
    return GoRoute(
      name: home.name,
      path: home.path,
      builder: (context, state) {
        return RepositoryProvider(
          create: (context) => CounterRepository(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CounterBloc(
                  repository: RepositoryProvider.of<CounterRepository>(context),
                ),
              ),
              BlocProvider(
                create: (context) => SuccessBloc(
                  repository: RepositoryProvider.of<CounterRepository>(context),
                ),
              ),
            ],
            child: const CounterScreen(
              title: 'Counter App',
            ),
          ),
        );
      },
    );
  }
}
