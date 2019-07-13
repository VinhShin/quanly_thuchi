import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thuchi/repository/user_repository.dart';
import 'package:thuchi/login/login.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  LoginBloc _loginBloc;
  TabController _controller;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        // here the desired height
        child: new AppBar(
          bottom: new TabBar(
            controller: _controller,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.person),
                text: 'Admin',
              ),
              new Tab(
                icon: new Icon(Icons.people_outline),
                text: 'User',
              ),
              //new Tab(text:'Email',),
              //new Tab(text:'User',),
            ],
          ),
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        children: <Widget>[
          BlocProvider<LoginBloc>(
            bloc: _loginBloc,
            child: LoginForm(userRepository: _userRepository),
          ),
          BlocProvider<LoginBloc>(
            bloc: _loginBloc,
            child: LoginFormUser(userRepository: _userRepository),
          ),
        ],
        // body: BlocProvider<LoginBloc>(
        //  bloc: _loginBloc,
        //  child: LoginForm(userRepository: _userRepository),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _loginBloc.dispose();
    super.dispose();
  }
}
