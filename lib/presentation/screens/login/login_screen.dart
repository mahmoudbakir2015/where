import 'package:flutter/material.dart';
import 'package:where/presentation/screens/login/items.dart';
import '../../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: phoneAuthCubit.phoneFormKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIntroTexts(),
                  const SizedBox(
                    height: 110,
                  ),
                  buildPhoneFormField(context: context),
                  const SizedBox(
                    height: 70,
                  ),
                  buildNextButton(context),
                  buildPhoneNumberSubmitedBloc(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
