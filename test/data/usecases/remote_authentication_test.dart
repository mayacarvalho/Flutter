import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:ForDev/domain/usecases.dart';

class RemoteAuthentication{
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post');
  } 
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main(){
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
  })

  test('Should call HttpClient with correct URL', ()async){(
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post'
      body: {'email': email, 'password': secret}
    ));
  )};
}