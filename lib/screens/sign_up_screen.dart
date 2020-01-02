import 'package:flutter/material.dart';

enum Gender {
  Male,
  Female,
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ///[FocusNodes] and [TextEditingControllers] to control text inputs
  ///and navigate between textInputs..
  ///They are also disposed after use in the @override dispose(){} method
  Gender _selectedGender = Gender.Male;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _maleFocusNode = FocusNode();

  @override
  void dispose() {
    _userNameController.dispose();
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
              FocusScope.of(context).requestFocus(_emailFocusNode);
            },
          ),
        ),
      ],
    );

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
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'nelsonchime@gmail.com',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                ))),
            controller: _emailController,
            focusNode: _emailFocusNode,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
          ),
        ),
      ],
    );

    ///[PASSWORD] field
    ///
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
            onSubmitted: (_) {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            userName,
            SizedBox(height: 10),
            email,
            SizedBox(height: 10),
            passWord,
            SizedBox(height: 10),
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
                onPressed: () {
                  //TODO: Implement Sign UP.
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
    );
  }
}
