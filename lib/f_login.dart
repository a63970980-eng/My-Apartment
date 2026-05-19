import 'package:flutter/material.dart';
import 'package:my_apart/admin_login.dart';
import 'package:my_apart/user_login.dart';

class FLogin extends StatelessWidget {
  const FLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              SizedBox(
                height: 220,
                child: Image.asset(
                  "assets/images/flog.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "نظام إدارة المجمع السكني",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "اختر نوع الدخول",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 40),

              // Admin Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("دخول الإدارة"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A84C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminLogin(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // User Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("دخول المستخدم"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserLogin(),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              const Text(
                "Government Housing System",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}