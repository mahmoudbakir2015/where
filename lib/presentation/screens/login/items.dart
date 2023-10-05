import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../../constnats/my_colors.dart';
import '../../../constnats/strings.dart';

Widget buildIntroTexts() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'What is your phone number?',
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 30,
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: const Text(
          'Please enter your phone number to verify your account.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    ],
  );
}

Widget buildPhoneFormField({required BuildContext context}) {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.lightGrey),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Text(
            '${phoneAuthCubit.generateCountryFlag()} +20',
            style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
          ),
        ),
      ),
      const SizedBox(
        width: 16,
      ),
      Expanded(
        flex: 2,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.blue),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: TextFormField(
            autofocus: true,
            style: const TextStyle(
              fontSize: 18,
              letterSpacing: 2.0,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
            cursorColor: Colors.black,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number!';
              } else if (value.length < 11) {
                return 'Too short for a phone number!';
              }
              return null;
            },
            onSaved: (value) {
              phoneAuthCubit.phoneNumber = value!;
            },
          ),
        ),
      ),
    ],
  );
}

Widget buildPhoneNumberSubmitedBloc({required BuildContext context}) {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
  return BlocListener<PhoneAuthCubit, PhoneAuthState>(
    listenWhen: (previous, current) {
      return previous != current;
    },
    listener: (context, state) {
      if (state is Loading) {
        showProgressIndicator(context);
      }

      if (state is PhoneNumberSubmited) {
        Navigator.pop(context);
        Navigator.of(context)
            .pushNamed(otpScreen, arguments: phoneAuthCubit.phoneNumber);
      }

      if (state is ErrorOccurred) {
        Navigator.pop(context);
        String errorMsg = (state).errorMsg;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    },
    child: Container(),
  );
}

Widget buildNextButton(BuildContext context) {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
  return Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton(
      onPressed: () {
        showProgressIndicator(context);

        phoneAuthCubit.register(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(110, 50),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: const Text(
        'Next',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

void showProgressIndicator(BuildContext context) {
  AlertDialog alertDialog = const AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    ),
  );

  showDialog(
    barrierColor: Colors.white.withOpacity(0),
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return alertDialog;
    },
  );
}
