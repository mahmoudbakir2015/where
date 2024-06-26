import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import '../../../constants/my_colors.dart';
import '../../../constants/strings.dart';

Widget buildIntroTexts({required phoneNumber}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Verify your phone number',
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 30,
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: RichText(
          text: TextSpan(
            text: 'Enter your 6 digit code numbers sent to ',
            style:
                const TextStyle(color: Colors.black, fontSize: 18, height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text: '$phoneNumber',
                style: const TextStyle(color: MyColors.blue),
              ),
            ],
          ),
        ),
      ),
    ],
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

Widget buildPinCodeFields(BuildContext context) {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
  return PinCodeTextField(
    appContext: context,
    autoFocus: true,
    cursorColor: Colors.black,
    keyboardType: TextInputType.number,
    length: 6,
    obscureText: false,
    animationType: AnimationType.scale,
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      borderWidth: 1,
      activeColor: MyColors.blue,
      inactiveColor: MyColors.blue,
      inactiveFillColor: Colors.white,
      activeFillColor: MyColors.lightBlue,
      selectedColor: MyColors.blue,
      selectedFillColor: Colors.white,
    ),
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: Colors.white,
    enableActiveFill: true,
    onCompleted: (submitedCode) {
      phoneAuthCubit.otpCode = submitedCode;
    },
    onChanged: (value) {},
  );
}

Widget buildVerifyButton(BuildContext context) {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit.get(context);
  return Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton(
      onPressed: () {
        showProgressIndicator(context);

        phoneAuthCubit.login(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(110, 50),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: const Text(
        'Verify',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

Widget buildPhoneVerificationBloc() {
  return BlocListener<PhoneAuthCubit, PhoneAuthState>(
    listenWhen: (previous, current) {
      return previous != current;
    },
    listener: (context, state) {
      if (state is Loading) {
        showProgressIndicator(context);
      }

      if (state is PhoneOTPVerified) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(mapScreen);
      }

      if (state is ErrorOccurred) {
        //Navigator.pop(context);
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
