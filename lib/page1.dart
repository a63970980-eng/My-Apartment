import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_apart/admin_home.dart';
import 'package:my_apart/f_login.dart';
import 'package:my_apart/user_home.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({super.key});

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    try {
      // Check admin
      final adminDoc = await FirebaseFirestore.instance
          .collection('Secretary')
          .doc(user.uid)
          .get();

      if (adminDoc.exists && adminDoc.data()?['userUid'] == user.uid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );
        return;
      }

      // Check user in Members
      final memberQuery = await FirebaseFirestore.instance
          .collectionGroup('Members')
          .where('userUid', isEqualTo: user.uid)
          .get();

      if (memberQuery.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserHome()),
        );
        return;
      }

      // default fallback
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF081420),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC9A84C),
          ),
        ),
      );
    }

    return const FLogin();
  }
}