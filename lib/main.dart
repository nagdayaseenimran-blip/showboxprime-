import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(const ShowBoxPrimeApp());
}

class ShowBoxPrimeApp extends StatelessWidget {
  const ShowBoxPrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShowBox Prime',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF121212),
          selectedItemColor: Color(0xFFE50914),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Data configuration for all 4 sections
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Movies',
      'url': 'https://www.flickbizz.com.pk/movies',
      'items': [
        {
          'title': 'Action Movie Stream 1',
          'streamUrl': 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-bubble-41556-large.mp4',
          'image': 'https://picsum.photos/300/450?random=1',
        },
        {
          'title': 'Sci-Fi Feature',
          'streamUrl': 'https://assets.mixkit.co/videos/preview/mixkit-group-of-friends-partying-happily-4640-large.mp4',
          'image': 'https://picsum.photos/300/450?random=2',
        },
      ]
    },
    {
      'title': 'Videos',
      'url': 'https://www.flickbizz.com.pk/videos',
      'items': [
        {
          'title': 'Trending Clip 1',
          'streamUrl': 'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
          'image': 'https://picsum.photos/300/450?random=3',
        },
      ]
    },
    {
      'title': 'Music',
      'url': 'https://www.flickbizz.com.pk/music',
      'items': [
        {
          'title': 'Official Music Track',
          'streamUrl': 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-41549-large.mp4',
          'image': 'https://picsum.photos/300/450?random=4',
        },
      ]
    },
    {
      'title': 'Web TV',
      'url': 'https://www.flickbizz.com.pk/webtv',
      'items': [
        {
          'title': 'Web TV Broadcast Live',
          'streamUrl': 'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
          'image': 'https://picsum.photos/300/450?random=5',
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentSection = _sections[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 1.2),
            children: const [
              TextSpan(text: 'SHOWBOX ', style: TextStyle(color: Color(0xFFE50914))),
              TextSpan(text: 'PRIME', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Hero Banner Section
            Container(
              height: 220,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(currentSection['items'][0]['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _playVideo(
                      context,
                      currentSection['items'][0]['title'],
                      currentSection['items'][0]['streamUrl'],
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Featured'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Popular in ${currentSection['title']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Horizontal Netflix Cards List
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (currentSection['items'] as List).length,
                itemBuilder: (context, index) {
                  final item = currentSection['items'][index];
                  return GestureDetector(
                    onTap: () => _playVideo(context, item['title'], item['streamUrl']),
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Videos'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Web TV'),
        ],
      ),
    );
  }

  void _playVideo(BuildContext context, String title, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomVideoPlayerScreen(title: title, videoUrl: videoUrl),
      ),
    );
  }
}

// Built-in Native Player Class
class CustomVideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const CustomVideoPlayerScreen({super.key, required this.title, required this.videoUrl});

  @override
  State<CustomVideoPlayerScreen> createState() => _CustomVideoPlayerScreenState();
}

class _CustomVideoPlayerScreenState extends State<CustomVideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFE50914),
        handleColor: const Color(0xFFE50914),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(color: Color(0xFFE50914)),
      ),
    );
  }
}
