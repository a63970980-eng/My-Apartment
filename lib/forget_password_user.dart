import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_apart/user_login.dart';

class ForgotPasswordMember extends StatefulWidget {
  const ForgotPasswordMember({super.key});

  @override
  State<ForgotPasswordMember> createState() => _ForgotPasswordMemberState();
}

class _ForgotPasswordMemberState extends State<ForgotPasswordMember> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("تم الإرسال"),
          content: const Text(
              "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UserLogin()),
                  (route) => false,
                );
              },
              child: const Text("حسناً"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("خطأ"),
          content: Text(e.toString()),
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: const Text("استعادة كلمة المرور"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset,
                size: 80, color: Color(0xFFC9A84C)),

            const SizedBox(height: 20),

            const Text(
              "أدخل بريدك الإلكتروني",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "سوف يتم إرسال رابط إعادة التعيين",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            Form(
              key: formKey,
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "البريد الإلكتروني",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon:
                      const Icon(Icons.email, color: Color(0xFFC9A84C)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFC9A84C)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "أدخل البريد الإلكتروني" : null,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A84C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Text(
                        "إرسال الرابط",
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
    );
  }
}