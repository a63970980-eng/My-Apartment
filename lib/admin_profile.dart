import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_apart/admin_home.dart';

class profile_admin extends StatefulWidget {
  const profile_admin({super.key});

  @override
  State<profile_admin> createState() => _profile_adminState();
}

class _profile_adminState extends State<profile_admin> {
  String name = "";
  String email = "";

  Future<void> loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot["name"] ?? "";
          email = snapshot["email"] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text("الملف الشخصي"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => admin_home()),
            );
          },
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 30),

          const CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),

          const SizedBox(height: 20),

          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),

          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.verified_user, color: Color(0xFF0D47A1)),
                  title: Text("حساب حكومي موثّق"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.security, color: Color(0xFF0D47A1)),
                  title: Text("نظام آمن ومشفر"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.support_agent, color: Color(0xFF0D47A1)),
                  title: Text("دعم البلاغات والخدمات"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}