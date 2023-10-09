import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../lib/presentation/presenters/protocols/protocols.dart';
import '../../../lib/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;
  
  PostExpectation mockValidationCall(String field) =>
    when(validation.validate(field: field == null ? anyNamed('field'), value: anyNamed('value')));
  
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();
  });

  test('Should call Validation with correct email', () {
    sut.ValidateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listem(expectAsinc1((error) => expect(error, 'error')));

    sut.ValidateEmail(email);
    sut.ValidateEmail(email);

  });
}