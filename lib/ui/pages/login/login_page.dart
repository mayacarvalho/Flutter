import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import './login.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter.mainErrorStream.listen((error) {
          showErrorMessage(context, error);
                });

        return GestureDetector(
          onTap: () => _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                Headline1(text: R.string.login),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: ListenableProvider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          EmailInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          TextButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: Icon(Icons.person),
                              label: Text(R.string.addAccount))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
