import 'package:flutter/material.dart';

import '../../factories.dart';
import '../../../../ui/pages/login/login.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}
