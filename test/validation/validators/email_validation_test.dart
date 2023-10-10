import 'package:Flutter/validation/validators/protocols/protocols.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    return null;
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
}