import 'package:flutter/material.dart';

import './welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _userNameHasError = false; //for validation
  bool _passwordHasError = false; // " "
  bool _isLoading = false; //To display circularProgressIndicator
  final _userNameController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  //when button is clicked.. validation is done here
  void validateForm() {
    if (_userNameController.text.isEmpty) {
      setState(() {
        _userNameHasError = true;
        FocusScope.of(context).requestFocus(_userNameFocusNode);
      });
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordHasError = true;
      });
    } else {
      _userNameHasError = false;
      _passwordHasError = false;
      setState(() {
        _isLoading = true;
      });
      //TODO: Database checks and logins should be here.. and delay should be removed
      Future.delayed(Duration(seconds: 2)).then((_) {
        _isLoading = false;
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    
    //Username input
    final userName = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.person,
          size: 36,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            focusNode: _userNameFocusNode,
            decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Nelson Chime',
                errorText: _userNameHasError ? '' : null,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                ))),
            controller: _userNameController,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
          ),
        ),
      ],
    );

    //Password Input
    final passWord = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 36,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              errorText: _passwordHasError ? '' : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: true,
            controller: _passwordController,
            focusNode: _passwordFocusNode,
          ),
        ),
      ],
    );

    //***************Showing screen, separated because of circularProgressIndicator showing in Stack
    final screen = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            userName,
            SizedBox(height: 10),
            passWord,
            SizedBox(
              height: 30,
            ),
            const Text(
              'Forgot Password?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: mediaquery.size.width - 32,
              child: RaisedButton(
                onPressed: validateForm,
                child: Text('LOGIN'),
              ),
            ),
            const SizedBox(height: 20),
            //SignInFromSocialAccounts(),
          ],
        ),
      ),
    );
    return _isLoading
        ? Stack(
            children: <Widget>[
              screen,
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : screen;
  }
}
