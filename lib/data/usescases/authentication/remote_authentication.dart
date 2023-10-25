import 'package:firstapp/data/http/http_error.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';

import '../../http/http_client.dart';
import '../../models/models.dart';

class RemoteAuthentication implements Authentication{
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient, 
    required this.url
  });

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final HttpResponse = await httpClient.request(url: url, 
        method: 'post', 
        body: body
      );
      return RemoteAccountModel.fromJson(HttpResponse).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.unauthorized
        ? DomainError.invalidCredentials
        : DomainError.unexpected;
    }   
  } 
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password
  })

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(email: params.email, password: params.secret);
  }

  //Converte para um Json
  Map toJson() => {'email': email, 'password': password};
}