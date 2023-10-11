import 'package:firstapp/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should retutn null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should retutn null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should retutn null if email is valid', () {
    expect(sut.validate('mayannara@outlook.com'), null);
  });

  test('Should retutn null if email is valid', () {
    expect(sut.validate('maya'), 'Campo inválido');
  });
}
