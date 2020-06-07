import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../providers/auth.dart';
import './mainpage_screen.dart';
import '../components/background_with_footers.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _emailHasError = false; //for validation
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _isLoading = false; //To display circularProgressIndicator
  bool _passwordHasError = false; // " "
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //when button is clicked.. validation is done here
  void validateForm() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailHasError = true;
        FocusScope.of(context).requestFocus(_emailFocusNode);
      });
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordHasError = true;
      });
    } else {
      _emailHasError = false;
      _passwordHasError = false;
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .logUserIn(_emailController.text.trim(), _passwordController.text.trim());
        _isLoading = false;
      } catch (e) {
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

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    //email input
    final email = Row(
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
            focusNode: _emailFocusNode,
            decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailHasError ? '' : null,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                ))),
            controller: _emailController,
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
              errorText: _passwordHasError ? '' : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: true,
            onSubmitted: (_) {},
            controller: _passwordController,
            focusNode: _passwordFocusNode,
          ),
        ),
      ],
    );

    //***************Showing screen, separated because of circularProgressIndicator showing in Stack
    final screen = Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            email,
            SizedBox(height: 10),
            passWord,
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(RecoverPasswordScreen.routeName),
              child: const Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
              ),
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
    return ModalProgressHUD(child: screen, inAsyncCall: _isLoading);
  }
}
///[EXTRA SCREEN HERE]
///
///
///
class RecoverPasswordScreen extends StatefulWidget {
  static const routeName = 'password-recover';

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  bool _hasError = false;
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void _validateAndSubmit() async {
      if (_textController.text == '') {
        setState(() {
          _hasError = true;
        });
        return;
      } else if (!_textController.text.contains('@')) {
        setState(() {
          _hasError = true;
        });
        return;
      } else {
        setState(() {
          _hasError = false;
        });
        try {
          await Provider.of<Auth>(context, listen: false)
              .recoverPassword(email: _textController.text);
          Navigator.of(context).popAndPushNamed(MainpageScreen.routeName); 
        } catch (e) {
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
      }
    }

    return BackgroundWithFooter(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Life and Success'),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    errorText: _hasError ? 'Invalid Email' : null,
                    labelText: 'Email address',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                RaisedButton(
                  child: Text('SEND'),
                  onPressed: _validateAndSubmit,
                ),
              ],
            )),
      ),
    );
  }
}
///Two classes are available in this screen
///1. LoginScreen()
///2. ForgotPasswordScreen()