import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/chat.dart';
import 'controllers/contact.dart';
import 'controllers/settings.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // List of screens for each BottomNavigationBar item
  final List<Widget> _pages = [
    const ContactsPage(),
    const ChatPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),  // Keep the same font size when selected
        unselectedLabelStyle: TextStyle(fontSize: 14), // Keep the same font size when not selected
      ),
    );
  }
}