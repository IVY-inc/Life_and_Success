import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../providers/auth.dart';
import './welcome_screen.dart';
import '../models/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ///[FocusNodes] and [TextEditingControllers] to control text inputs
  ///and navigate between textInputs..
  ///They are also disposed after use in the @override dispose(){} method
  GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  Gender _selectedGender = Gender.Male;
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _maleFocusNode = FocusNode();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _confirmPasswordFocusNode.dispose();
    _passwordConfirmController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _maleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    ///[EMAIL] email input field
    ///**** */
    final email = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.mail,
          size: 36,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Email',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                ))),
            controller: _emailController,
            validator: (value) {
              if (!value.contains('@')) {
                return 'Invalid Email address';
              }
              if (!value.contains('.')) {
                return 'Invalid Email address';
              }
              return null;
            },
            focusNode: _emailFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
          ),
        ),
      ],
    );

    ///[PASSWORD] field
    ///
    final password = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 36,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value.length <= 6) {
                return 'Password is not strong enough';
              }
              return null;
            },
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
          ),
        ),
      ],
    );
    final confirmPassword = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 36,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            focusNode: _confirmPasswordFocusNode,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: true,
            controller: _passwordConfirmController,
            validator: (val) {
              if (val != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_maleFocusNode);
            },
          ),
        ),
      ],
    );
    var maleRadioGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio(
          groupValue: _selectedGender,
          focusNode: _maleFocusNode,
          value: Gender.Male,
          //title: Text('Male'),
          onChanged: (x) {
            setState(() {
              _selectedGender = x;
            });
          },
        ),
        Text('Male'),
      ],
    );
    var femaleRadioGroup = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio(
          groupValue: _selectedGender,
          value: Gender.Female,
          //title: Text('Male'),
          onChanged: (x) {
            setState(() {
              _selectedGender = x;
            });
          },
        ),
        Text('Female'),
      ],
    );
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                email,
                SizedBox(height: 10),
                password,
                SizedBox(height: 10),
                confirmPassword,
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      maleRadioGroup,
                      femaleRadioGroup,
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: mediaquery.size.width - 32,
                  child: RaisedButton(
                    onPressed: () async {
                      bool _hasError = false;
                      if (!_formKey.currentState.validate()) {
                        return;
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .signUp(
                            _emailController.text,
                            _passwordController.text,
                            _selectedGender,
                          );
                        } catch (e) {
                          _hasError = true;
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Okay'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                )
                              ],
                              content: Text(e.toString()),
                              title: Text('An error occured!'),
                            ),
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                        if(!_hasError)
                        Navigator.of(context)
                            .pushReplacementNamed(WelcomeScreen.routeName);
                      } //TODO: Username setup instead
                    },
                    child: Text('SIGNUP'),
                  ),
                ),
                SizedBox(height: 20),
                //SignInFromSocialAccounts(
                //TODO: Implement receiving data from Social Media Accounts
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
