import 'package:flutter/material.dart';
import 'package:news1_app/constans/theme.dart';
import 'package:news1_app/pages/home_page.dart';
import 'package:news1_app/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = primaryColor;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        backgroundColor: selectedColor,
        selectedIconTheme: IconThemeData(
          color: whiteColor,
        ),
        selectedLabelStyle: TextStyle(
          color: whiteColor,
        ),
        unselectedLabelStyle: TextStyle(
          color: whiteColor.withOpacity(0.5),
        ),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/ic/home.png',
              color: _selectedIndex == 0
                  ? whiteColor
                  : whiteColor.withOpacity(0.5),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/ic/profile.png',
              color: _selectedIndex == 1
                  ? whiteColor
                  : whiteColor.withOpacity(0.5),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: whiteColor,
        unselectedItemColor: whiteColor.withOpacity(0.5),
        onTap: _onItemTapped,
      ),
    );
  }
}
