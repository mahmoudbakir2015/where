import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../../constnats/my_colors.dart';
import '../../../constnats/strings.dart';

PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

Widget buildDrawerHeader(context) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blue[100],
        ),
        child: Image.asset(
          'assets/images/mahmoud.JPG',
          fit: BoxFit.cover,
        ),
      ),
      const Text(
        'Mahmoud Bakir',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5,
      ),
      BlocProvider<PhoneAuthCubit>(
          create: (context) => phoneAuthCubit,
          child: Text(
            '${phoneAuthCubit.getLoggedInUser().phoneNumber}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
    ],
  );
}

Widget buildDrawerListItem(
    {required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color}) {
  return ListTile(
    leading: Icon(
      leadingIcon,
      color: color ?? MyColors.blue,
    ),
    title: Text(title),
    trailing: trailing ??= const Icon(
      Icons.arrow_right,
      color: MyColors.blue,
    ),
    onTap: onTap,
  );
}

Widget buildDrawerListItemsDivider() {
  return const Divider(
    height: 0,
    thickness: 1,
    indent: 18,
    endIndent: 24,
  );
}

void _launchURL(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

Widget buildIcon(
    {required IconData icon, required String url, required Color? color}) {
  return InkWell(
    onTap: () => _launchURL(url),
    child: Icon(
      icon,
      color: color,
      size: 35,
    ),
  );
}

Widget buildSocialMediaIcons() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 16),
    child: Row(
      children: [
        buildIcon(
          icon: FontAwesomeIcons.facebook,
          url: 'https://www.facebook.com/mahmoud.mahmoudbakir?mibextid=LQQJ4d',
          color: Colors.blue,
        ),
        const SizedBox(
          width: 15,
        ),
        buildIcon(
          icon: FontAwesomeIcons.youtube,
          url: 'https://www.youtube.com/channel/UCiD5DoAjwT5s4e15BerKVtQ',
          color: Colors.red,
        ),
        const SizedBox(
          width: 20,
        ),
        buildIcon(
          icon: FontAwesomeIcons.telegram,
          url: 'https://t.me/modybakir',
          color: const Color(0xff239AD6),
        ),
      ],
    ),
  );
}

Widget buildLogoutBlocProvider(context) {
  return BlocProvider<PhoneAuthCubit>(
    create: (context) => phoneAuthCubit,
    child: buildDrawerListItem(
      leadingIcon: Icons.logout,
      title: 'Logout',
      onTap: () async {
        await phoneAuthCubit.logOut();
        Navigator.of(context).pushReplacementNamed(loginScreen);
      },
      color: Colors.red,
      trailing: const SizedBox(),
    ),
  );
}
