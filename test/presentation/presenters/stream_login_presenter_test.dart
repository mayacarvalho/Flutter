import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:Flutter/domain/entities/entities.dart';
import 'package:Flutter/domain/usecases/usecases.dart';

import 'package:Flutter/presentation/presenters/presenters.dart';
import 'package:Flutter/presentation/presenters/protocols/protocols.dart';


class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  AuthenticationSpy authentication;
  ValidationSpy validation;
  String email;
  String password;
  
  PostExpectation mockValidationCall(String field) =>
    when(validation.validate(field: field === null ? anyNamed('field') : field, value: anyNamed('value')));
  
  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));
  
  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
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

  test('Should call Authentication with correct values', () async{
    sut.ValidateEmail(email);
    sut.ValidatePassword(password);
    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password ))).called(1);
  });
  
  test('Should emit correct events on Authentication succees', () async {
    sut.ValidateEmail(email);
    sut.ValidatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });
}