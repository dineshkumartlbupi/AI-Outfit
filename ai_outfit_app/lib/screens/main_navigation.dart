import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'home_screen.dart';
import 'templates_screen.dart';
import 'ai_studio_screen.dart';
import 'wardrobe_screen.dart';
import 'photo_upload_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TemplatesScreen(),
    const AIStudioScreen(),
    const WardrobeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardDark,
          border: Border(
            top: BorderSide(color: AppTheme.strokeDark, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high_outlined),
              activeIcon: Icon(Icons.auto_fix_high),
              label: 'AI Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'My Looks',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhotoUploadScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        label: const Text(
          'Try On AI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
