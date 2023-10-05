import 'package:flutter/material.dart';
import 'package:where/presentation/widgets/drawer/items.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(
            leadingIcon: Icons.person,
            title: 'My Profile',
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.settings,
            title: 'Settings',
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.help,
            title: 'Help',
          ),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const Spacer(),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: buildSocialMediaIcons(),
          ),
        ],
      ),
    );
  }
}
