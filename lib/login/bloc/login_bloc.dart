import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thuchi/login/login.dart';
import 'package:thuchi/repository/user_repository.dart';
import 'package:thuchi/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(Stream<LoginEvent> events,
      Stream<LoginState> Function(LoginEvent event) next,) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    }else if (event is UidChanged) {
      yield* _mapUidChangedToState(event.uid);
    } else if (event is UpassChanged) {
      yield* _mapUPasswordChangedToState(event.upass);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is LoginWithSubUserPressed) {
      yield* _mapLoginWithSubUserPressedToState(
        uid: event.uid,
        upassword: event.upassword,
      );
    } else if (event is SavePassCheck) {
      yield* _mapSavePass(event.email, event.pass, event.check);
    }
    //
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapUidChangedToState(String uid) async* {
    yield currentState.update(
      isUidvalid: Validators.isValidUid(uid),
    );
  }

  Stream<LoginState> _mapUPasswordChangedToState(String upassword) async* {
    yield currentState.update(
      isUpasswordValid: Validators.isValidUpass(upassword),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      //await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
  //login sub_user
  Stream<LoginState> _mapLoginWithSubUserPressedToState({
    String uid,
    String upassword,
  }) async* {
    yield LoginState.loading();
    try {
      if(await _userRepository.signInWithSubUser(uid, upassword))
        yield LoginState.success();
      else yield LoginState.failure();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapSavePass(
    String email, String pass, bool check) async* {

  }
}
