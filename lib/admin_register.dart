import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_apart/admin_login.dart';
import 'package:my_apart/page1.dart';

class admin_register extends StatefulWidget {
  const admin_register({Key? key}) : super(key: key);

  @override
  State<admin_register> createState() => _admin_registerState();
}

class _admin_registerState extends State<admin_register> {
  final form_key = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await users.doc(cred.user!.uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "uid": cred.user!.uid,
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "تم إنشاء الحساب بنجاح");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page1()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "فشل إنشاء الحساب");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text("إنشاء حساب"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => admin_login()));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: form_key,
          child: Column(
            children: [
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "الاسم الكامل",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "الاسم مطلوب" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "البريد الإلكتروني",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "الإيميل مطلوب" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "كلمة المرور",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.length < 6 ? "كلمة المرور قصيرة" : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: loading
                      ? null
                      : () {
                          if (form_key.currentState!.validate()) {
                            register();
                          }
                        },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("إنشاء حساب"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}