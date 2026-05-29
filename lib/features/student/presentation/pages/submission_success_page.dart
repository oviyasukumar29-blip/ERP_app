import 'package:flutter/material.dart';

class SubmissionSuccessPage extends StatefulWidget {
  const SubmissionSuccessPage({super.key});

  @override
  State<SubmissionSuccessPage> createState() =>
      _SubmissionSuccessPageState();
}

class _SubmissionSuccessPageState
    extends State<SubmissionSuccessPage>
    with TickerProviderStateMixin {

  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutCubic,
      ),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: FadeTransition(
              opacity: _fadeAnimation,

              child: SlideTransition(
                position: _slideAnimation,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // TOP EMOJI
                    const Text(
                      "🎉",
                      style: TextStyle(fontSize: 70),
                    ),

                    const SizedBox(height: 18),

                    // SUCCESS ICON
                    ScaleTransition(
                      scale: _scaleAnimation,

                      child: Container(
                        width: 150,
                        height: 150,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1FA45B),
                              Color(0xFF32C56F),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(.25),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.check_rounded,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // TITLE
                    const Text(
                      "Assignment Completed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SUBTITLE
                    const Text(
                      "Excellent work! Your assignment\nhas been submitted successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    // XP CARD
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.elasticOut,

                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },

                      child: Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1FA45B),
                              Color(0xFF32C56F),
                            ],
                          ),

                          borderRadius: BorderRadius.circular(30),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(.2),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            const Text(
                              "✨ GREAT JOB ✨",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 22),

                            // PREMIUM BADGE
                            Container(
                              width: 120,
                              height: 120,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(.15),
                              ),

                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                size: 72,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // STARS ANIMATION
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.elasticOut,

                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [

                                  Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 42,
                                  ),

                                  SizedBox(width: 10),

                                  Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 52,
                                  ),

                                  SizedBox(width: 10),

                                  Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 42,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // XP
                            const Text(
                              "+25 XP",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 10),

                            // STREAK
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Text(
                                    "🔥",
                                    style: TextStyle(fontSize: 20),
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "5 Day Streak!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        

                            const SizedBox(height: 22),

                            // LEVEL
                            const Text(
                              "Level 7 Scholar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              "Assignment Submitted",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 28),

                            // PROGRESS
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: LinearProgressIndicator(
                                value: 0.72,
                                minHeight: 12,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              "72 XP to next level 🚀",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ),

                    const SizedBox(height: 50),

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111827),
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}