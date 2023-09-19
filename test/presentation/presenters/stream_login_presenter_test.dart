import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  validate({
    @required String field, 
    @required String value
  });
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});
  void ValidateEmail(String email){
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;
  
  setUp(() {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();
  });

  test('Should call Validation with correct email', () {
    sut.ValidateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}