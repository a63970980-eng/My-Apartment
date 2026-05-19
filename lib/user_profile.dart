import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup('Members')
          .where('userUid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userData = snapshot.docs.first.data();
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: const Text("الملف الشخصي"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC9A84C),
              ),
            )
          : userData == null
              ? const Center(
                  child: Text(
                    "لا توجد بيانات",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        userData!["Name"] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        userData!["Email"] ?? "",
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 30),

                      _buildInfoCard("رقم الشقة", userData!["Flat Number"]),
                      _buildInfoCard("عدد المركبات",
                          userData!["Number of vehicles"]),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String title, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132847),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "$value",
            style: const TextStyle(
              color: Color(0xFFC9A84C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}