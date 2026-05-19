import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_apart/Auth/otp_Auth_Sec.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      EmailAuth emailAuth = EmailAuth(sessionName: "Gov Services App");

      bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.text.trim(),
        otpLength: 6,
      );

      if (result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OTP_SEC(email: _emailController.text.trim()),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "فشل إرسال رمز التحقق، حاول مرة أخرى");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "حدث خطأ: $e");
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  "assets/images/Email1.png",
                  height: 200,
                ),

                const SizedBox(height: 20),

                const Text(
                  "تسجيل الدخول عبر البريد",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "البريد الإلكتروني",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFC9A84C)),
                    filled: true,
                    fillColor: const Color(0xFF132847),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "أدخل البريد الإلكتروني";
                    }
                    if (!value.contains("@")) {
                      return "بريد غير صالح";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A84C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "إرسال رمز التحقق",
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
      ),
    );
  }
}