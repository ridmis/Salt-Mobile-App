import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double spacing = 16.0;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // First Row
                  Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _buildAdminButton(
                            context,
                            "Add Users & Admins",
                            '/addUser',
                          ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _buildAdminButton(
                            context,
                            "Create New Items",
                            '/createItems',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing),

                  // Second Row (Single Button)
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: _buildAdminButton(
                      context,
                      "Report Section",
                      '/reportSection',
                    ),
                  ),

                  SizedBox(height: spacing),

                  // Third Row
                  Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _buildAdminButton(
                            context,
                            "Analyse Section",
                            '/analyseSection',
                          ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _buildAdminButton(
                            context,
                            "Reading Section",
                            '/readingSection',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing),

                  // Fourth Row (Single Button)
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: _buildAdminButton(
                      context,
                      "Change Current Items",
                      '/changeItems',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildAdminButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.secondary, width: 3),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
