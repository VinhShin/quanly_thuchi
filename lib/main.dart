import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuchi/authentication_bloc/bloc.dart';
import 'package:thuchi/repository/user_repository.dart';
import 'package:thuchi/login/login.dart';
import 'package:thuchi/splash_screen.dart';
import 'package:thuchi/simple_bloc_delegate.dart';
import 'package:thuchi/home_page/home_page.dart';

main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authenticationBloc,
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          'logout': (BuildContext context) => new LoginScreen(userRepository: _userRepository),
          'revenue_expenditure': (BuildContext context) => new HomePage(_userRepository),

        },
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
//              return HomeScreen(name: state.displayName);
              return HomePage(_userRepository);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
