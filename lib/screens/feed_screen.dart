import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import '../widgets/checkout_sheet.dart';
import '../core/event_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _categoryController = PageController();
  int _activeCategoryIndex = 0;
  final List<String> _categories = [
    "All",
    "Club",
    "Concert",
    "Chill",
    "Live Band",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. HORIZONTAL CATEGORY SWIPE
          PageView.builder(
            controller: _categoryController,
            onPageChanged: (index) =>
                setState(() => _activeCategoryIndex = index),
            itemCount: _categories.length,
            itemBuilder: (context, catIndex) =>
                CategoryFeed(category: _categories[catIndex]),
          ),

          // 2. GLASSMORPHISM CATEGORY CHIPS
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  bool isActive = _activeCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => _categoryController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF00FFA3)
                                : Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isActive
                                  ? Colors.transparent
                                  : Colors.white10,
                            ),
                          ),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: isActive
                                  ? Colors.black
                                  : Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryFeed extends StatelessWidget {
  final String category;
  const CategoryFeed({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('events');
    if (category != "All") {
      query = query.where('category', isEqualTo: category.toLowerCase());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
          );
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              "Coming soon...",
              style: TextStyle(color: Colors.white24),
            ),
          );
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return VideoEventTile(
              event: NightlifeEvent(
                title: data['title'] ?? '',
                venue: data['venue'] ?? '',
                price: data['price']?.toString() ?? '0',
                imageUrl: data['videoUrl'] ?? data['imageUrl'] ?? '',
              ),
              vibeLevel: data['vibeLevel']?.toString() ?? '80',
            );
          },
        );
      },
    );
  }
}

class VideoEventTile extends StatefulWidget {
  final NightlifeEvent event;
  final String vibeLevel;
  const VideoEventTile({
    super.key,
    required this.event,
    required this.vibeLevel,
  });

  @override
  State<VideoEventTile> createState() => _VideoEventTileState();
}

class _VideoEventTileState extends State<VideoEventTile> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.event.imageUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
                _controller.setLooping(true);
                _controller.play();
                _controller.setVolume(0);
              });
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. VIDEO
        SizedBox.expand(
          child: _isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white12),
                ),
        ),

        // 2. BOTTOM GRADIENT
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
              stops: [0.5, 1.0],
            ),
          ),
        ),

        // 3. REFINED VIBE SIDEBAR
        Positioned(
          right: 15,
          bottom: 160,
          child: Column(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Color(0xFF00FFA3),
                size: 30,
              ),
              Text(
                "${widget.vibeLevel}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black45,
                  child: Icon(Icons.storefront, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),

        // 4. MINIMALIST INFO & CTA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  shadows: [Shadow(blurRadius: 12, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF00FFA3),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.event.venue,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              CheckoutSheet(event: widget.event),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFA3),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "GET TICKETS",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${widget.event.price} TZS",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }
}
