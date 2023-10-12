import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/login/login.dart';

import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}
