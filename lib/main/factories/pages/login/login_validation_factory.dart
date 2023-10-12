import '../../../../presentation/presenters/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import 'package:firstapp/validation/validators/protocols/protocols.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password')
  ];
}
