import 'dart:convert';

class AccountEntity{
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJason(Map Jason) =>
    AccountEntity(json['accessToken']);
}