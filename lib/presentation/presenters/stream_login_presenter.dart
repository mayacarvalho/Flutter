
import 'dart:async';

import './protocols/protocols.dart';
import 'package:meta/meta.dart';

class LoginState {
  String emailError;
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required required this.validation});

  void ValidateEmail(String email){
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }

  void ValidatePassword(String password){
    validation.validate(field: 'password', value: password);
  }
}