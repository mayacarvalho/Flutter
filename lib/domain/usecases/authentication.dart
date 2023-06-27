import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final Strinf email;
  final String secret;

  AuthenticationParams({
    @required this.mail,
    @required this.secret
  })
}