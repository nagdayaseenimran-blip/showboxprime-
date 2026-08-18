import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Movies',
      'url': 'https://www.flickbizz.com.pk/movies',
      'icon': Icons.movie_outlined,
      'activeIcon': Icons.movie,
    },
    {
      'title': 'Videos',
      'url': 'https://www.flickbizz.com.pk/videos',
      'icon': Icons.play_circle_outline,
      'activeIcon': Icons.play_circle_fill,
    },
    {
      'title': 'Music',
      'url': 'https://www.flickbizz.com.pk/music',
      'icon': Icons.music_note_outlined,
      'activeIcon': Icons.music_note,
    },
    {
      'title': 'Web TV',
      'url': 'https://www.flickbizz.com.pk/webtv',
      'icon': Icons.tv_outlined,
      'activeIcon': Icons.tv,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.bebasNeue(
                  fontSize: 28,
                  letterSpacing: 1.2,
                ),
                children: const [
                  TextSpan(
                    text: 'SHOWBOX ',
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'PRIME',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _sections
            .map((section) => SectionWebView(url: section['url']))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _sections.map((section) {
          return BottomNavigationBarItem(
            icon: Icon(section['icon']),
            activeIcon: Icon(section['activeIcon']),
            label: section['title'],
          );
        }).toList(),
      ),
    );
  }
}

class SectionWebView extends StatefulWidget {
  final String url;
  const SectionWebView({super.key, required this.url});

  @override
  State<SectionWebView> createState() => _SectionWebViewState();
}

class _SectionWebViewState extends State<SectionWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE50914),
            ),
          ),
      ],
    );
  }
}
