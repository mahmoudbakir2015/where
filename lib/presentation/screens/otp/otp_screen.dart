import 'package:flutter/material.dart';

import 'package:where/presentation/screens/otp/items.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
          child: Column(
            children: [
              buildIntroTexts(phoneNumber: phoneNumber),
              const SizedBox(
                height: 88,
              ),
              buildPinCodeFields(context),
              const SizedBox(
                height: 60,
              ),
              buildVerifyButton(context),
              buildPhoneVerificationBloc(),
            ],
          ),
        ),
      ),
    );
  }
}
