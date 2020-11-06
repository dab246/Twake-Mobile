import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twake_mobile/services/twake_api.dart';
import 'package:twake_mobile/config/dimensions_config.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String username;
  String password;
  final GlobalKey<FormState> formKey = GlobalKey();

  /// Closure to store the username from form field
  void onUsernameSaved(value) => username = value;

  /// Closure to store the password from form field
  void onPasswordSaved(value) {
    password = value;
  }

  String validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  Future<void> onSubmit(BuildContext ctx) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    try {
      await Provider.of<TwakeApi>(ctx, listen: false)
          .authenticate(username, password);
    } catch (error) {
      print(error);
      Scaffold.of(ctx)
          .showSnackBar(SnackBar(content: Text('Failed to authorize')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: 83 * DimensionsConfig.widthMultiplier,
        height: 47 * DimensionsConfig.heightMultiplier,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 7 * DimensionsConfig.widthMultiplier,
            vertical: 0.3 * DimensionsConfig.heightMultiplier,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    'Sign in to Twake',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Center(
                  child: Text(
                    'Happy to see you \u{1F607}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(height: 3 * DimensionsConfig.heightMultiplier),
                _AuthTextForm(
                  label: 'Username or e-mail',
                  validator: validatePassword,
                  onSaved: onUsernameSaved,
                ),
                _AuthTextForm(
                  label: 'Password',
                  obscured: true,
                  validator: validateUsername,
                  onSaved: onPasswordSaved,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0.7 * DimensionsConfig.heightMultiplier,
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.button,
                    ),
                    // allows to login no matter what, have to implement authentication logic first
                    onPressed: () => onSubmit(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTextForm extends StatelessWidget {
  final String label;
  final bool obscured;
  final void Function(String) onSaved;
  final String Function(String) validator;
  const _AuthTextForm({
    @required this.label,
    @required this.onSaved,
    this.validator,
    this.obscured: false,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscured,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(238, 238, 238, 0.9),
        filled: true,
        labelText: label,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
  }
}
