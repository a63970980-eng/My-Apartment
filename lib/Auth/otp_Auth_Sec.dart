import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OTP_SEC extends StatefulWidget {
  final String email;

  const OTP_SEC({super.key, required this.email});

  @override
  State<OTP_SEC> createState() => _OTP_SECState();
}

class _OTP_SECState extends State<OTP_SEC> {
  final EmailAuth emailAuth = EmailAuth(sessionName: "Gov Services App");
  final OtpFieldController _otpController = OtpFieldController();

  bool loading = false;

  void verifyOTP(String otp) async {
    setState(() => loading = true);

    bool res = emailAuth.validateOtp(
      recipientMail: widget.email,
      userOtp: otp,
    );

    setState(() => loading = false);

    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم التحقق بنجاح")),
      );

      // هنا تروح للصفحة الرئيسية
      // Navigator.pushReplacement(...)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رمز غير صحيح")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 80, color: Color(0xFFC9A84C)),

              const SizedBox(height: 20),

              const Text(
                "التحقق من الرمز",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "تم إرسال رمز إلى:\n${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 30),

              OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  verifyOTP(pin);
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                          // لا نستخدم controller.toString (كان خطأ)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("أدخل الكود أولاً"),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A84C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "تحقق",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}