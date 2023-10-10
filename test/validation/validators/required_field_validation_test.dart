import 'package:test/test.dart';

import 'package:Flutter/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_field'), null);
  });

  test('Should return null if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });

  test('Should return null if value is null', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });
}
