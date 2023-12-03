
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final phoneCtrl = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Verification"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                label: Text("Phone Number"),
                hintText: "Enter phone number",
                border: OutlineInputBorder(),
              ),
              onChanged: (phone) {
                setState(() {
                  phoneNumber = phone;
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                String str = phoneNumber.substring(0, 1);

                if (str == "0") {
                  phoneNumber = phoneNumber.substring(1, phoneNumber.length);
                }
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: "+855$phoneNumber",
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {},
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: const Center(
                  child: Text(
                    "Send Code",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
