import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/AddPools.dart';
import 'package:myapp/AddTypes.dart';
import 'package:myapp/AddLewaya.dart';

class CreateItems extends StatelessWidget {
  const CreateItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar with back button and title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.thirtary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Create New Items',
                      style: TextStyle(
                        color: AppColors.thirtary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStyledButton("Add Lewaya", () {
                        showAddLewayaDialog(context);
                      }),
                      const SizedBox(height: 16),
                      _buildStyledButton("Add Type", () {
                        showAddTypeDialog(context);
                      }),
                      const SizedBox(height: 16),
                      _buildStyledButton("Add Pool", () {
                        showAddPoolDialog(
                          context,
                        ); // Show dialog instead of navigation
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.thirtary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
