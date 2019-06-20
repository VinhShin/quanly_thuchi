import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class UidChanged extends LoginEvent {
  final String uid;

  UidChanged({@required this.uid}) : super([uid]);

  @override
  String toString() => 'UidChanged { uid :$uid }';
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class UpassChanged extends LoginEvent {
  final String upass;

  UpassChanged({@required this.upass}) : super([upass]);

  @override
  String toString() => 'UpassChanged { upass: $upass }';
}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginWithGooglePressed extends LoginEvent {
  @override
  String toString() => 'LoginWithGooglePressed';
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
class LoginWithSubUserPressed extends LoginEvent {
  final String uid;
  final String upassword;

  LoginWithSubUserPressed({@required this.uid, @required this.upassword})
      : super([uid, upassword]);

  @override
  String toString() {
    return 'LoginWithSubUserPressed { uid: $uid, password: $upassword }';
  }
}

class SavePassCheck extends LoginEvent{
  final String email;
  final String pass;
  final bool check;

  SavePassCheck({@required this.email, @required this.pass, @required this.check}):super([email, pass, check]);

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
