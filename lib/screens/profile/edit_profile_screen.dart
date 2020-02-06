import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../providers/auth.dart';

import '../../models/constants.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Gender _gender;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    try {
      Provider.of<Auth>(context, listen: false).getUserGender().then((g) {
        _gender = g;
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  void updateProfile(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 30),
              Text('Warning'),
            ],
          ),
          content: Text(
              'Are you sure you want to leave this page without saving changes?'),
          actions: <Widget>[
            FlatButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true)),
            RaisedButton(
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
          ],
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Your Profile'),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<Auth>(builder: (_, auth, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'profilepic',
                      child: CircleAvatar(
                        minRadius: 30,
                        maxRadius: mediaquery.size.width * 0.3,
                        backgroundImage: NetworkImage(
                            auth.user.photoUrl == '' ||
                                    auth.user.photoUrl == null
                                ? kProfileImage
                                : auth.user.photoUrl),
                      ),
                    ),
                    FlatButton(
                      child: Text('UPLOAD PICTURE'),
                      onPressed: () {},
                    ),
                    SizedBox(height: 30),
                    // TextFormField(),
                    // TextFormField(),
                    // TextFormField(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            title: Text('Male'),
                            value: Gender.Male,
                            groupValue: _gender,
                            onChanged: (gen) {
                              setState(() {
                                _gender = gen;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text('Female'),
                            value: Gender.Female,
                            groupValue: _gender,
                            onChanged: (gen) => setState(
                              () {
                                _gender = gen;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      child: Text('Save'.toUpperCase()),
                      onPressed: () => updateProfile(context),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
