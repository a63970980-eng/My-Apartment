import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_apart/chat/Member/pages/group_page_user.dart';
import 'package:my_apart/user_login.dart';
import 'package:my_apart/user_profile.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _drawerController = AdvancedDrawerController();

  void _toggleDrawer() {
    _drawerController.showDrawer();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const UserLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _drawerController,
      backdropColor: const Color(0xFF0B1F3A),
      animationDuration: const Duration(milliseconds: 250),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),

      child: Scaffold(
        backgroundColor: const Color(0xFF081420),

        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1F3A),
          title: const Text(
            'منصة الخدمات الحكومية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleDrawer,
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GroupPageUser()),
                );
              },
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCard(Icons.report, "البلاغات"),
              _buildCard(Icons.build, "الخدمات"),
              _buildCard(Icons.notifications, "الإشعارات"),
              _buildCard(Icons.person, "الملف الشخصي"),
            ],
          ),
        ),
      ),

      drawer: SafeArea(
        child: Container(
          color: const Color(0xFF0B1F3A),
          child: Column(
            children: [
              const SizedBox(height: 30),

              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),

              const SizedBox(height: 20),

              const Text(
                "المواطن",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text("الملف الشخصي",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProfile()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text("تسجيل خروج",
                    style: TextStyle(color: Colors.white)),
                onTap: _logout,
              ),

              const Spacer(),

              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "منصة حكومية رقمية",
                  style: TextStyle(color: Colors.white38),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF132847),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFC9A84C), size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}