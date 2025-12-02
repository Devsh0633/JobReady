import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/community/presentation/community_theme.dart';
import '../app_spacing.dart';

class CommunityHeroButton extends StatefulWidget {
  final VoidCallback onTap;
  const CommunityHeroButton({super.key, required this.onTap});

  @override
  State<CommunityHeroButton> createState() => _CommunityHeroButtonState();
}

class _CommunityHeroButtonState extends State<CommunityHeroButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  double _tapScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _tapScale,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _tapScale = 0.96),
        onTapUp: (_) {
          setState(() => _tapScale = 1.0);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _tapScale = 1.0),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CommunityTheme.backgroundTop,
                CommunityTheme.backgroundBottom,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Community",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: CommunityTheme.accentPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Discuss. Learn. Share. Become Job Ready Today",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black.withValues(alpha: 0.6),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.forum_rounded,
                        color: CommunityTheme.accentPurple,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
