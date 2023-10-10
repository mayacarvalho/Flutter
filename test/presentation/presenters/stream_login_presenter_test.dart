import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../lib/domain/usecases/authentication.dart';
import '../../../lib/presentation/presenters/protocols/protocols.dart';
import '../../../lib/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  AuthenticationSpy authentication;
  ValidationSpy validation;
  String email;
  String password;
  
  PostExpectation mockValidationCall(String field) =>
    when(validation.validate(field: field == null ? anyNamed('field'), value: anyNamed('value')));
  
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.ValidateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listem(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, false)));

    sut.ValidateEmail(email);
    sut.ValidateEmail(email);

  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listem(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, false)));

    sut.ValidateEmail(email);
    sut.ValidateEmail(email);

  });

  test('Should call Validation with correct password', () {
    sut.ValidatePassword(password);
    
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listem(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, false)));

    sut.ValidateEmail(email);
    sut.ValidateEmail(email);
  });

  test('Should emit password error if validation fails', () {
    sut.passwordErrorStream.listem(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, false)));

    sut.ValidatePassword(password);
    sut.ValidatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream.listem(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listem(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, false)));

    sut.ValidateEmail(email);
    sut.ValidatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    sut.emailErrorStream.listem(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listem(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listem(expectAsync1((isValid) => expect(isValid, true)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.ValidateEmail(email);
    await Future.delayed(Duration.zero); //Para dar tempo de renderizar a tela
    sut.ValidatePassword(password);
  });

  test('Should call Authentication with correct values', () {
    sut.ValidateEmail(email);
    sut.ValidatePassword(password);
    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password ))).called(1);
  });
}