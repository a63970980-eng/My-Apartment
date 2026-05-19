import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_apart/admin_login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final flatController = TextEditingController();
  final vehicleController = TextEditingController();

  bool loading = false;

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // Create user
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Save to Firestore (clean structure)
      await FirebaseFirestore.instance
          .collection("Members")
          .doc(uid)
          .set({
        "Name": nameController.text,
        "Email": emailController.text,
        "Flat Number": flatController.text,
        "Number of vehicles": vehicleController.text,
        "userUid": uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "تم إنشاء الحساب بنجاح");

      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AdminLogin()),
        (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "فشل إنشاء الحساب");
    }

    setState(() => loading = false);
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: const Color(0xFFC9A84C)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC9A84C)),
        ),
      ),
      validator: (value) =>
          value!.isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const Icon(Icons.person_add,
                  size: 80, color: Color(0xFFC9A84C)),

              const SizedBox(height: 10),

              const Text(
                "إنشاء حساب مواطن",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    buildField(nameController, "الاسم", Icons.person),
                    const SizedBox(height: 12),

                    buildField(emailController, "البريد الإلكتروني", Icons.email),
                    const SizedBox(height: 12),

                    buildField(passController, "كلمة المرور", Icons.lock),
                    const SizedBox(height: 12),

                    buildField(flatController, "رقم الشقة", Icons.home),
                    const SizedBox(height: 12),

                    buildField(vehicleController, "عدد المركبات", Icons.directions_car),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : signUp,
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
                                "إنشاء الحساب",
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
            ],
          ),
        ),
      ),
    );
  }
}