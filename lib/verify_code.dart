import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '/home_screen.dart';
import 'helper/global.dart';
import 'package:http/http.dart' as http;

class VerifyCode extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyCode(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;
  String smsCode = "";

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  _fnVerify(String verificationId, String smsCode) async {
    setState(() {
      _isLoading = true;
    });
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential);

      var res = await registerPhoneNum();
      if (res == "true") {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          alertMsg(
              context: context,
              content: "មានអ្វីមួយមិនប្រក្រតី មិនអាច Login បានទេ");
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        alertMsg(context: context, content: "លេខកូដមិនត្រឹមត្រវូ");
      });
    }
  }

  registerPhoneNum() async {
    var url = Uri.parse("$apiUrl/register-customer");
    var resp = await http.post(url, body: {
      "phone": "0${widget.phoneNumber}",
    });
    if (resp.statusCode == 200) {
      return "true";
    } else {
      return "false";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 40,
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(20.0),
                      child: Pinput(
                        onChanged: (code) {
                          smsCode = code;
                        },
                        length: 6,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          _fnVerify(widget.verificationId, smsCode);
                        },
                        child: const Center(
                          child: Text(
                            "Verify code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "osContent",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
