import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
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
            decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Nelson Chime',
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          userName,
          SizedBox(height: 10),
          passWord,
          SizedBox(
            height: 30,
          ),
          Text(
            'Forgot Password?',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),

          SizedBox(
            width: mediaquery.size.width - 32,
            child: RaisedButton(
              onPressed: () {},
              child: Text('LOGIN'),
            ),
          ),
          SizedBox(height: 20),
          //SignInFromSocialAccounts(),
        ],
      ),
    );
  }
}
