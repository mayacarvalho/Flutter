import 'dart:html';

import 'package:mockito/mockito.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client)

  Future<void> request({
    @required String url,
    @required String method
  }) async {

  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);

      await sut.request(url: url, method: 'post');

      verify(client.post(url));
    });
  });
}