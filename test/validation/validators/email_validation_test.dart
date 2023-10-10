import 'package:Flutter/validation/validators/protocols/protocols.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp("^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido';
  }
}

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
