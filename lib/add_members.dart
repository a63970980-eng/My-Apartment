import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_apart/admin_home.dart';

class AddCitizenScreen extends StatefulWidget {
  const AddCitizenScreen({Key? key}) : super(key: key);

  @override
  State<AddCitizenScreen> createState() => _AddCitizenScreenState();
}

class _AddCitizenScreenState extends State<AddCitizenScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nationalIdController = TextEditingController();

  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");

  bool loading = false;

  Future<void> addUser() async {
    setState(() => loading = true);

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = cred.user!.uid;

      await users.doc(uid).set({
        "uid": uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "nationalId": nationalIdController.text.trim(),
        "role": "citizen",
        "createdAt": FieldValue.serverTimestamp(),
      });

      await FirebaseAuth.instance.signOut();

      Fluttertoast.showToast(msg: "تم إضافة المواطن بنجاح");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => admin_home()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "فشل إضافة المستخدم");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة مواطن"),
        backgroundColor: const Color(0xff0B1F3A), // لون حكومي
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "الاسم"),
                validator: (v) => v!.isEmpty ? "أدخل الاسم" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
                validator: (v) => v!.isEmpty ? "أدخل البريد" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "كلمة المرور"),
                obscureText: true,
                validator: (v) => v!.length < 6 ? "ضعف كلمة المرور" : null,
              ),
              TextFormField(
                controller: nationalIdController,
                decoration: const InputDecoration(labelText: "الرقم الوطني"),
                validator: (v) => v!.isEmpty ? "أدخل الرقم الوطني" : null,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0B1F3A),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: loading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            addUser();
                          }
                        },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("إضافة مواطن"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}