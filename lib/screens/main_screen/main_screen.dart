import 'package:devpush/components/loader.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
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
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
    if (selectedIndex == 3) {
      Future.delayed(
          Duration.zero,
          () => Provider.of<DatabaseProvider>(context, listen: false)
              .setMedalNotification(false));
    }
  }

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => Provider.of<DatabaseProvider>(context, listen: false)
            .setLastLogin());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    UserModel user = databaseProvider.user;

    List<Widget> _screens = [
      HomeScreen(
        user: user,
      ),
      DiscoverScreen(),
      CommunityScreen(),
      ProfileScreen(
        user: user,
      )
    ];

    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: _onPageChanged,
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
            ),
            child: BottomNavigationBar(
              selectedItemColor: AppColors.blue,
              unselectedItemColor: AppColors.lightGray,
              // iconSize: 24,
              // selectedFontSize: 14,
              type: BottomNavigationBarType.shifting,
              // elevation: 8,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedLabelStyle: AppTextStyles.blueText,
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
                  // icon: Icon(Icons.person),
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.person),
                      if (databaseProvider.medalNotification)
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 6,
                              minHeight: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        ),
        Container(
          child: databaseProvider.isLoading ? Loader() : Container(),
        )
      ],
    );
  }
}
