import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/UpdateLewaya.dart';
import 'package:myapp/UpdateType.dart';
import 'package:myapp/UpdatePool.dart';
import 'package:myapp/DeleteLewaya.dart';
import 'package:myapp/DeleteTypes.dart';
import 'package:myapp/DeletePool.dart';

class ChangeItems extends StatelessWidget {
  const ChangeItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Current Items",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _styledButton(context, "Update Lewaya", () {
                showUpdateLewayaDialog(context);
              }),
              const SizedBox(height: 16),
              _styledButton(context, "Update Type", () {
                showUpdateTypeDialog(context);
              }),
              const SizedBox(height: 16),
              _styledButton(context, "Update Pool", () {
                showUpdatePoolDialog(context);
              }),
              const SizedBox(height: 40), // Extra space
              _styledButton(context, "Delete Lewaya", () {
                showDeleteLewayaDialog(context);
              }),
              const SizedBox(height: 16),
              _styledButton(context, "Delete Type", () {
                showDeleteTypeDialog(context);
              }),

              const SizedBox(height: 16),
              _styledButton(context, "Delete Pool", () {
                showDeletePoolDialog(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _styledButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        backgroundColor: Colors.white.withOpacity(0.95),
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        shadowColor: Colors.black45,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}
