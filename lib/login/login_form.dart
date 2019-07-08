import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_thuchi/repository/user_repository.dart';
import 'package:quanly_thuchi/authentication_bloc/bloc.dart';
import 'package:quanly_thuchi/login/login.dart';
import 'package:quanly_thuchi/dialog/TextFieldAlertDialog.java';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Đăng nhập thất bại'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đang xử lý...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          Navigator.of(context).pushReplacementNamed("revenue_expenditure");
//          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/flutter_logo.png', height: 200),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Email',
                    ),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                        Center(
                            child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                _showDialog(context, _emailController);
                              },
                              child: Text(
                                "Quên mật khẩu?",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        )),
                        CreateAccountButton(userRepository: _userRepository),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _savePass() {
    _loginBloc.dispatch(SavePassCheck(
        email: _emailController.text, pass: _passwordController.text));
  }

  _showDialog(
      BuildContext context, TextEditingController _textFieldController) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập gmail của bạn!'),
            content: TextField(
              controller: _textFieldController,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('lấy lại mật khẩu'),
                onPressed: () {
                  _userRepository.resetPassword(_emailController.text);
                  Navigator.of(context).pop();
                  _showDialogInfo();
                },
              ),
            ],
          );
        });
  }

  void _showDialogInfo() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Thông báo"),
          content: new Text("Mật khẩu mới đã được gửi đến gmail của bạn, bạn vui lòng kiểm tra mail để cập nhật mật khẩu mới!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
