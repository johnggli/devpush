import 'package:devpush/components/loader.dart';
import 'package:devpush/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:devpush/screens/home_screen/home_screen.dart';
import 'package:devpush/screens/discover_screen/discover_screen.dart';
import 'package:devpush/screens/community_screen/community_screen.dart';
import 'package:devpush/screens/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static String routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController();

  List<Widget> _screens = [
    HomeScreen(),
    DiscoverScreen(),
    CommunityScreen(),
    ProfileScreen()
  ];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context);

    return Stack(children: [
      Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[500],
          // iconSize: 24,
          // selectedFontSize: 14,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Descobrir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Comunidade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      Container(
        child: pageProvider.isLoading ? Loader() : Container(),
      )
    ]);
  }
}
