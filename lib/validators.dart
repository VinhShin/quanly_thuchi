class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );
  static final RegExp _uidRegExp = RegExp(
    r'^[A-Za-z\d]{1,}$',
  );
  static final RegExp _upassRegExp = RegExp(
    r'^[A-Za-z\d]{1,}$',
  );
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
  static isValidUid(String uid) {
    return _uidRegExp.hasMatch(uid);
  }

  static isValidUpass(String upassword) {
    return upassword.length>2;
  }
}
