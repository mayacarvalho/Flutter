import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../lib/data/http/http.dart';
import '../../../../lib/data/usescases/authentication/remote_authentication.dart';
import '../../../../lib/domain/usecases/usecases.dart';
import '../../../../lib/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;
  
  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};
  
  PostExpectation mockRequest() =>
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockHttpData(Map Data) {
    mockRequest().thenAnswer((_) async => data);
  }

 void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  } 

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct URL', () async {
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post'
      body: {'email': email, 'password': secret}
    ));
  });

  test('Should call HttpClient with correct values', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')))
      .thenAnswer((_) async => {'accessToken': faker.guid.guid(), 'name': faker.person.name()});
    
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post'
      body: {'email': params.email, 'password': params.secret}
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async{
    mockHttpError(HttpError.badRequest);

    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async{
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async{
   mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async{
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

//Teste generico que serve para qualquer caso de uso
  test('Should return an Account if HttpClient returns 200', () async{
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });

  test('Should return an Account if HttpClient returns 200 with invalid data', () async{
    mockHttpData({'invalid_key': 'invalid_key'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}