import 'package:firstapp/data/usescases/remote_authentication.dart';
import 'package:firstapp/infra/http/http_adapter.dart';
import 'package:firstapp/presentation/presenters/presenters.dart';
import 'package:firstapp/ui/pages/login/login_page.dart';
import 'package:firstapp/validation/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Widget makeLoginPage() {
  final url = 'http://fordevs.herokuapp.com/api/login';
  final client = Client();
  final httpAdapter = HttpAdapter(client);
  final remoteAuthentication =
      RemoteAuthentication(httpClient: httpAdapter, url: url);
  final validationComposite = ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password')
  ]);
  final streamLoginPresenter = StreamLoginPresenter(
      authentication: remoteAuthentication, validation: validationComposite);
  return LoginPage(streamLoginPresenter);
}
