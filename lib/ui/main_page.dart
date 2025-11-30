import 'package:flutter/material.dart';
import 'package:simple_dyphic/ui/calender/calendar_page.dart';
import 'package:simple_dyphic/ui/setting/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _menuView(_currentIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        elevation: 12.0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        items: _allDestinations
            .map((item) => BottomNavigationBarItem(
                  label: item.title,
                  icon: Icon(item.icon),
                ))
            .toList(),
        onTap: (i) {
          setState(() {
            _currentIdx = i;
          });
        },
      ),
    );
  }

  Widget _menuView(int index) {
    switch (index) {
      case 0:
        return const CalenderPage();
      default:
        return const SettingsPage();
    }
  }
}

final _allDestinations = <Destination>[
  const Destination('カレンダー', Icons.calendar_today),
  const Destination('設定', Icons.settings),
];

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}
