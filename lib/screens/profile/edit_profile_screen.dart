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
  Gender _remoteGender;
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
        _remoteGender = g;
        _gender = g;
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  void updateProfile(BuildContext context) async {
    bool errorOccured = false;
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    //TODO: Error handlings
    if (_gender != _remoteGender) {
      await Provider.of<Auth>(context).setUserGender(_gender);
    }
    setState(() {
      _isLoading = false;
    });
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 20),
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
    );
    Navigator.of(context).pop();
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
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
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
                      InputDecorator(
                        child: Text(auth.user.email),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          enabled: false,
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        validator: (val) {
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(4)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(4)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
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
                      ),
                      RaisedButton(
                        child: Text('Save'.toUpperCase()),
                        onPressed: () => updateProfile(context),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
