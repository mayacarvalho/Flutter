//Lib recebe o body em formato de string, tem que converter para o Json
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../lib/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client)

  Future<Map> request({
    @required String url,
    @required String method,
    Map body
  }) async {
      final headers = {
        'content-type': 'application/json',
        'accept': 'application/json'
      };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test('Should call post with correct values', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"any_key": "any_key"}'
      ));
    });
  });

  group('post', () {
    test('Should call post without body', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers')
      ));
    });
  });

  group('post', () {
    test('Should return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response,{ 'any_key': 'any_value'});
    });
  });

  group('post', () {
    test('Should return null if post returns 200 with no data', () async {
      when(client.post(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}