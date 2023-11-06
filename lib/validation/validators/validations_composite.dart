import '../../presentation/presenters/protocols/protocols.dart';

import '../validators/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({required String field, required String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      final error = validation.validate(value);
      if (error.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}
