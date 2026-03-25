import 'package:flutter/material.dart';

// ── Skeleton Grid (Members) ───────────────────────────────────────
class SkeletonMemberGrid extends StatelessWidget {
  const SkeletonMemberGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(), // no scroll during loading
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: 10, // show 10 skeleton cards
      itemBuilder: (_, __) => const SkeletonMemberCard(),
    );
  }
}

// ── Skeleton Card (Member) ───────────────────────────────────────
class SkeletonMemberCard extends StatefulWidget {
  const SkeletonMemberCard({super.key});

  @override
  State<SkeletonMemberCard> createState() => _SkeletonMemberCardState();
}

class _SkeletonMemberCardState extends State<SkeletonMemberCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Shimmer pulse animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final shimmerColor = Colors.white.withOpacity(_animation.value);

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00ADB5).withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              // ── Image placeholder ──────────────────
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: shimmerColor.withOpacity(_animation.value * 0.3),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white.withOpacity(0.05),
                      size: 48,
                    ),
                  ),
                ),
              ),

              // ── Text placeholders ──────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name placeholder
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: shimmerColor.withOpacity(
                              _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // JP name placeholder
                      Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                          color: shimmerColor.withOpacity(
                              _animation.value * 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subs placeholder
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: shimmerColor.withOpacity(
                                  _animation.value * 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            height: 10,
                            width: 60,
                            decoration: BoxDecoration(
                              color: shimmerColor.withOpacity(
                                  _animation.value * 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Skeleton List (Videos) ───────────────────────────────────────
class SkeletonVideoList extends StatelessWidget {
  const SkeletonVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      physics: const NeverScrollableScrollPhysics(), // no scroll during loading
      itemCount: 5, // show 5 skeleton cards
      itemBuilder: (_, __) => const SkeletonVideoCard(),
    );
  }
}

// ── Skeleton Card (Video) ───────────────────────────────────────
class SkeletonVideoCard extends StatefulWidget {
  const SkeletonVideoCard({super.key});

  @override
  State<SkeletonVideoCard> createState() => _SkeletonVideoCardState();
}

class _SkeletonVideoCardState extends State<SkeletonVideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Shimmer pulse animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final shimmerColor = Colors.white.withOpacity(_animation.value);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // ── Thumbnail placeholder ──────────────────
              Container(
                width: 120,
                height: 72,
                decoration: BoxDecoration(
                  color: shimmerColor.withOpacity(_animation.value * 0.3),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.video_library_rounded,
                    color: Colors.white.withOpacity(0.05),
                    size: 24,
                  ),
                ),
              ),

              // ── Text placeholders ──────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title placeholder
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: shimmerColor.withOpacity(
                            _animation.value * 0.3,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: shimmerColor.withOpacity(
                            _animation.value * 0.3,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Watch/Bookmark placeholder
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 50,
                            decoration: BoxDecoration(
                              color: shimmerColor.withOpacity(
                                _animation.value * 0.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: shimmerColor.withOpacity(
                                _animation.value * 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
