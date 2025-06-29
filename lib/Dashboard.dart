import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<double> _fadeAnimation1;
  late Animation<double> _scaleAnimation1;

  late Animation<double> _fadeAnimation2;
  late Animation<double> _scaleAnimation2;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeIn));

    _scaleAnimation1 = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOutBack));

    _fadeAnimation2 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeIn));

    _scaleAnimation2 = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeOutBack));

    _controller1.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _controller2.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Rainfall Button
                    FadeTransition(
                      opacity: _fadeAnimation1,
                      child: ScaleTransition(
                        scale: _scaleAnimation1,
                        child: _buildAnimatedButton(
                          context,
                          label: 'Rainfall',
                          imagePath: 'assets/rain1.jpg',
                          onPressed: () {
                            Navigator.pushNamed(context, '/rainfall');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Baume Reading Button
                    FadeTransition(
                      opacity: _fadeAnimation2,
                      child: ScaleTransition(
                        scale: _scaleAnimation2,
                        child: _buildAnimatedButton(
                          context,
                          label: 'Baume Reading',
                          imagePath: 'assets/Lewaya2.jpg',
                          onPressed: () {
                            Navigator.pushNamed(context, '/brine');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context, {
    required String label,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.thirtary,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.secondary, width: 6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image not found',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Label text
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    shadows: const [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black45,
                        offset: Offset(1, 2),
                      ),
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
}
