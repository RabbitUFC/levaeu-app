import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:levaeu_app/hive/user.dart';
import 'package:levaeu_app/screens/home/create_ride.dart';
import 'package:levaeu_app/screens/home/home.dart';
import 'package:levaeu_app/theme.dart';
import 'package:levaeu_app/utils/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);
  static String routeName = '/home/page-view';

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
  }

  List<Widget> _buildScreens() {
    return [
      const Scaffold(),
      const Home(),
      const Scaffold(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(Color color, String userType) {
    return [
      PersistentBottomNavBarItem(
        icon: const Center(
          child: FaIcon(
            FontAwesomeIcons.undo,
            size: 22,
          )
        ),
        activeColorPrimary: color,
        inactiveColorPrimary: Colors.grey,
      ),
      if (userType == 'passenger')
        PersistentBottomNavBarItem(
          icon: Center(
            child: FaIcon(
              FontAwesomeIcons.home,
              size: 22,
              color: color
            )
          ),
          activeColorPrimary: color,
          inactiveColorPrimary: Colors.grey,
        ),
      if (userType == 'driver')
          PersistentBottomNavBarItem(
          icon: GestureDetector(
            onTap: () {
              pushNewScreen(
                context,
                screen: const CreateRide(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                size: 22,
                color: Colors.white
              )
            ),
          ),
          activeColorPrimary: color,
          inactiveColorPrimary: Colors.grey,
        ),
      PersistentBottomNavBarItem(
        icon: const Center(
          child: FaIcon(
            Icons.chat,
            size: 22,
          )
        ),
        activeColorPrimary: color,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      ValueListenableBuilder(
        valueListenable: Hive.box(userBox).listenable(),
        builder: (BuildContext context, Box box, Widget? child) {
          User user = box.get('user');
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(user.selectedType == 'passenger' ? appPrimaryColor : appSecondaryColor, user.selectedType),
            confineInSafeArea: true,
            navBarHeight: kBottomNavigationBarHeight,
            margin: const EdgeInsets.all(0.0),
            popActionScreens: PopActionScreensType.all,
            onWillPop: (context) async {
              await showDialog(
                context: context!,
                useSafeArea: true,
                builder: (context) => Container(
                  height: 50.0,
                  width: 50.0,
                  color: Colors.red,
                  child: ElevatedButton(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
              return false;
            },
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(0.0)
            ),
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 500),
            ),
            navBarStyle: user.selectedType == 'passenger' ? NavBarStyle.style14 : NavBarStyle.style15,
          );
        }
      )
    );
  }
}