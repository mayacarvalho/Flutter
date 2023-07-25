import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:Flutter/domain/usecases/usecases.dart';

import 'package:Flutter/data/usecases/usecases.dart';
import 'package:Flutter/data/http/http.dart';

import '../../../lib/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
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

  test('Should throw UnexpectedError if HttpClient returns 400', () async{
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')))
      .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth();

    expect(future, throwsA(DomainError.unexpected));
  });
}