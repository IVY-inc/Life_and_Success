import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/auth.dart';

import '../../models/constants.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _pickedImage;
  Gender _gender;
  Gender _remoteGender;
  bool _isLoading = false;
  bool doneB = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _usernameController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  setGender() async {
    try {
      _isLoading = true;
      await Provider.of<Auth>(context, listen: false).getUserGender().then((g) {
        _remoteGender = g;
        _gender = g;
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setGender();
    super.initState();
  }

  void updateProfile(BuildContext context) async {
    bool errorOccured = false;
    if (!_formKey.currentState.validate()) {
      return;
    }
    final authProvider = Provider.of<Auth>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    //TODO: Error handlings
    if (_usernameController.text != authProvider.user.displayName) {
      authProvider.updateUsername(_usernameController.text);
    }
    if (_gender != _remoteGender) {
      await authProvider.setUserGender(_gender);
    }
    if (_pickedImage != null) {
      await authProvider.uploadProfilepic(_pickedImage);
    }
    setState(() {
      _isLoading = false;
    });
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(errorOccured ? Icons.warning : Icons.verified_user,
                color: errorOccured ? Colors.red : Colors.green, size: 36),
            SizedBox(width: 10),
            Text(errorOccured ? 'Warning' : 'Success'),
          ],
        ),
        content: Text(errorOccured
            ? 'An error occured while updating profile'
            : 'Profile successfully updated!'),
        actions: <Widget>[
          if (errorOccured)
            FlatButton(
              child: Text('Retry'),
              color: Colors.green,
              onPressed: () {
                Navigator.of(ctx).pop();
                updateProfile(context);
              },
            ),
          FlatButton(
            onPressed: () {
              errorOccured
                  ? Navigator.of(ctx).pop()
                  : Navigator.of(context).pop(true);
            },
            textColor: Colors.red,
            child: Text('Close'),
          ),
        ],
      ),
    );
    if (!errorOccured) {
      Navigator.of(context).pop();
    }
  }

  Widget radioButton(Gender value) {
    return Expanded(
      child: RadioListTile(
        title: Text(value.toString().split('.')[1]),
        value: value,
        groupValue: _gender,
        onChanged: (gen) => setState(
          () {
            _gender = gen;
          },
        ),
      ),
    );
  }

  Widget textFormField(
      {TextEditingController controller,
      @required IconData icon,
      Function validator,
      String labelText}) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 36),
        Expanded(
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

//ModalBottom Sheet creater.. Because of this the image File has to be somewhere outside our EditProfile class so
//_image can be callable from outside the class.. wait.. I am thinking of something.. what if we use {static call?}
  Widget imageOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    Navigator.of(context).pop(imageFile);
                  }),
              Text('Camera')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () async {
                    File image = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.of(context).pop(image);
                  }),
              Text('Gallery')
            ],
          ),
        ],
      ),
    );
  }

  void pickImageModalSheet() async {
    _pickedImage = await showModalBottomSheet<File>(
        context: context, builder: (ctx) => imageOptions(ctx));
    setState(() {});
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
                //get the display Name.. if this is the first time.. help the user get a displayName
                if (!doneB) {
                  _usernameController.text = auth.user.displayName == null ||
                          auth.user.displayName == ''
                      ? auth.user.email.substring(
                          0,
                          min(
                            auth.user.email.indexOf('.'),
                            auth.user.email.indexOf('@'),
                          ),
                        )
                      : auth.user.displayName;
                  doneB = true;
                }

                ///*******View Head [THIS] is where the UI starts.. I am tired of scrolling lol but this is one busy screen though */
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: auth.user.photoUrl == '' ||
                                auth.user.photoUrl == null
                            ? kProfileImage
                            : auth.user.photoUrl,
                        placeholder: (_, __) => CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => Icon(Icons.error),
                        imageBuilder: (_, imageProvider) => Hero(
                          tag: 'profilepic',
                          child: CircleAvatar(
                            minRadius: 30,
                            maxRadius: mediaquery.size.width * 0.3,
                            backgroundImage: _pickedImage == null
                                ? imageProvider
                                : FileImage(_pickedImage),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (ctx) => FlatButton(
                          textColor: Theme.of(context).accentColor,
                          child: Text('UPLOAD PICTURE'),
                          onPressed: pickImageModalSheet,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.mail,
                            size: 36,
                          ),
                          Expanded(
                            child: InputDecorator(
                              child: Text(auth.user.email),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                enabled: false,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      textFormField(
                        icon: Icons.person,
                        validator: (val) {
                          if (val.length < 4) {
                            return 'Username too short';
                          }
                          return null;
                        },
                        controller: _usernameController,
                        labelText: 'Username',
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          radioButton(Gender.Male),
                          radioButton(Gender.Female),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text('Save'.toUpperCase()),
                          onPressed: () => updateProfile(context),
                        ),
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
