import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:my_apart/add_members.dart';
import 'package:my_apart/admin_login.dart';
import 'package:my_apart/chat/Admin/pages/group_page_admin.dart';
import 'package:my_apart/member_list.dart';
import 'package:my_apart/admin_profile.dart';

class admin_home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _controller,
      backdropColor: const Color(0xFF0D47A1),

      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: const Color(0xFF0D47A1),
          title: const Text("نظام الخدمات الحكومية"),
          centerTitle: true,

          leading: IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, value, __) {
                return Icon(
                  value.visible ? Icons.close : Icons.menu,
                );
              },
            ),
            onPressed: () => _controller.showDrawer(),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupPageAdmin()),
                );
              },
            )
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "مرحباً بك 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "لوحة التحكم - إدارة البلاغات والخدمات",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              _buildCard("📢 إدارة البلاغات", Colors.red),
              _buildCard("🛠 إدارة الخدمات", Colors.blue),
              _buildCard("👥 المستخدمين", Colors.green),
            ],
          ),
        ),
      ),

      drawer: SafeArea(
        child: Container(
          color: const Color(0xFF0D47A1),
          child: Column(
            children: [

              const SizedBox(height: 40),

              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),

              const SizedBox(height: 20),

              const Text(
                "لوحة التحكم",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 30),

              _item(Icons.home, "الرئيسية", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => admin_home()));
              }),

              _item(Icons.person, "الملف الشخصي", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => profile_admin()));
              }),

              _item(Icons.add, "إضافة مستخدم", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SignUpScreen()));
              }),

              _item(Icons.list, "قائمة المستخدمين", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => member_list()));
              }),

              _item(Icons.logout, "تسجيل خروج", () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => admin_login()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      iconColor: Colors.white,
      textColor: Colors.white,
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildCard(String title, Color color) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}