import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tiktok/components/password_text_field.dart';
import 'package:flutter_tiktok/components/text_form_builder.dart';
import 'package:flutter_tiktok/utils/validations.dart';
import 'package:flutter_tiktok/view/auth/register.dart';
import 'package:flutter_tiktok/view_model/auth/login_view_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return ModalProgressHUD(
inAsyncCall: viewModel.loading,
progressIndicator: CircularProgressIndicator(),
          child: Scaffold(
        key: viewModel.scaffoldKey,
        appBar: AppBar(
          title: Text('TikTok'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
               Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.0
                ),
              ),
              SizedBox(height:MediaQuery.of(context).size.width / 2.5),
             
              buildForm(context,viewModel),
            ],
          ),
        ),
      ),
    );
  }

  buildForm(BuildContext context, LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Column(
          children: [
            TextFormBuilder(
              enabled: !viewModel.loading,
              prefix: Feather.mail,
              hintText: "Email",
              textInputAction: TextInputAction.next,
              validateFunction: Validations.validateEmail,
              onSaved: (String val) {
                viewModel.setEmail(val);
              },
              focusNode: viewModel.emailFN,
              nextFocusNode: viewModel.passFN,
            ),
            SizedBox(height: 15.0),
            PasswordFormBuilder(
              enabled: !viewModel.loading,
              prefix: Feather.lock,
              suffix: Feather.eye,
              hintText: "Password",
              textInputAction: TextInputAction.done,
              validateFunction: Validations.validatePassword,
              submitAction: () => viewModel.login(context),
              obscureText: true,
              onSaved: (String val) {
                viewModel.setPassword(val);
              },
              focusNode: viewModel.passFN,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () => viewModel.forgotPassword(),
                  child: Container(
                    width: 130,
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 45.0,
              width: 180.0,
              child: RaisedButton(
                highlightElevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Theme.of(context).accentColor,
                child: Text(
                  'Sign in'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => viewModel.login(context),
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 120,
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 45.0,
              width: 180.0,
              child: RaisedButton(
                highlightElevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.grey,
                child: Text(
                  'Sign Up'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => Register(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
