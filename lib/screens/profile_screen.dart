import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './profile/edit_profile_screen.dart';
import '../models/constants.dart';

class ProfileItem {
  final String title;
  final String subTitle;
  final IconData icon;
  final bool isIcon;
  final Function onClick;
  final String imageUrl;
  ProfileItem(
      {@required this.title,
      this.subTitle,
      this.icon,
      this.isIcon = true,
      @required this.onClick,
      this.imageUrl});
}

class ProfileScreen extends StatelessWidget {
  Widget section(
      {BuildContext context,
      @required bool hasHeader,
      String header,
      List<ProfileItem> items}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (hasHeader)
          Container(
            padding: EdgeInsets.only(left: 16, top: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              header.toUpperCase(),
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        for (int i = 0; i < items.length; i++)
          i == items.length - 1
              ? ListTile(
                  title: items[i].title == null
                      ? null:Text(items[i].title),
                  subtitle: items[i].subTitle == null
                      ? null
                      : Text(items[i].subTitle),
                  onTap: items[i].onClick,
                  leading: items[i].isIcon
                      ? Icon(
                          items[i].icon,
                          color: Colors.black,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(items[i].imageUrl),
                        ),
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text(items[i].title),
                      subtitle: items[i].subTitle == null
                          ? null
                          : Text(items[i].subTitle),
                      onTap: items[i].onClick,
                      leading: items[i].isIcon
                          ? Icon(
                              items[i].icon,
                              color: Colors.black,
                            )
                          : Hero(
                              tag: 'profilepic',
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(items[i].imageUrl),
                              ),
                            ),
                    ),
                    Divider(),
                  ],
                ),
      ],
    );
  }
  //Function sections[to handle the numerous onClicks from each View]
  //
  //

  @override
  Widget build(BuildContext context) {
    final List<Widget> sectionLists = <Widget>[
      Consumer<Auth>(
        builder: (__, auth, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: section(
            context: context,
            hasHeader: false,
            items: [
              ProfileItem(
                isIcon: false,
                imageUrl: auth.user.photoUrl ?? kProfileImage,
                title: auth.user.displayName == ''||auth.user.displayName==null
                    ? auth.user.email.substring(
                        0,
                        min(
                          auth.user.email.indexOf('.'),
                          auth.user.email.indexOf('@'),
                        ),
                      )
                    : auth.user.displayName,
                subTitle: auth.user.email,
                onClick: () => Navigator.of(context)
                    .pushNamed(EditProfileScreen.routeName),
              )
            ],
          ),
        ),
      ),
      section(
        hasHeader: true,
        header: 'account',
        items: [
          ProfileItem(title: 'My Profile', icon: Icons.person, onClick: () {}),
          ProfileItem(
              title: 'My Progress and rewards',
              icon: Icons.pie_chart,
              onClick: () {})
        ],
      ),
      section(
        hasHeader: true,
        header: 'alert',
        items: [
          ProfileItem(
            title: 'Reminder',
            icon: Icons.event_note,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Favorites',
            icon: Icons.favorite,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Notification',
            icon: Icons.notifications_active,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Daily quotes',
            icon: Icons.format_quote,
            onClick: () {},
          ),
        ],
      ),
      section(
        hasHeader: true,
        header: 'settings',
        items: [
          ProfileItem(
            title: 'Sync my progress',
            icon: Icons.sync,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Languages',
            icon: Icons.translate,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Payment',
            icon: Icons.payment,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Sleep and activity monitor',
            icon: Icons.person,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Child protection',
            icon: Icons.child_care,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Phone locker',
            icon: Icons.screen_lock_portrait,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Time interference',
            icon: Icons.watch_later,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Delete account',
            icon: Icons.delete_forever,
            onClick: () {},
          ),
        ],
      ),
      section(
        hasHeader: true,
        header: 'Help & Legal',
        items: [
          ProfileItem(
            title: 'Help',
            icon: Icons.help,
            onClick: () {},
          ),
          ProfileItem(
            title: 'Policies',
            icon: Icons.person,
            onClick: () {},
          ),
        ],
      ),
      section(
        hasHeader: false,
        items: [
          ProfileItem(title: 'Logout', onClick: () {}, icon: Icons.person),
        ],
      )
    ];
    return SafeArea(
      child: ListView.separated(
        separatorBuilder: (_, __) => Container(
            width: double.infinity, height: 8, color: Colors.grey[200]),
        itemCount: sectionLists.length,
        itemBuilder: (_, index) => sectionLists[index],
      ),
    );
  }
}
