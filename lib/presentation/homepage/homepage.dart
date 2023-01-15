import 'package:flutter/material.dart';
import 'package:pengingat_list/common/constants.dart';
import 'package:pengingat_list/presentation/calendar_page/calendar_page.dart';
import 'package:pengingat_list/presentation/profile_page/profile_page.dart';
import 'package:pengingat_list/presentation/task_page/tasklist_page.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  PageController page = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    TasklistPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  bool isOpened = false;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  toggleMenu() {
    final state = _sideMenuKey.currentState!;
    if (state.isOpened) {
      state.closeSideMenu();
    } else {
      state.openSideMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SideMenu(
        key: _sideMenuKey,
        menu: buildMenu(),
        type: SideMenuType.slide,
        onChange: (isOpened) {
          setState(() => isOpened = isOpened);
        },
        child: IgnorePointer(
          ignoring: isOpened,
          child: Scaffold(
              body: GestureDetector(
                onTap: () {
                  _sideMenuKey.currentState!.closeSideMenu();
                },
                child: _pages.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: buttomNavigationBar()),
        ),
      ),
    );
  }

  buttomNavigationBar() => Container(
        width: Size.infinite.width,
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => toggleMenu(),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                backgroundColor: Colors.white,
                onTap: _onItemTapped,
                elevation: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'Activity'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month), label: 'Calendar'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'My Profile'),
                ],
              ),
            ),
          ],
        ),
      );
  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(name, style: TextStyle(color: Colors.white, fontSize: 32)),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.star_border, size: 20.0, color: Colors.white),
            title: const Text("Favorites"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.category, size: 20.0, color: Colors.white),
            title: const Text('Category'),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.feedback, size: 20.0, color: Colors.white),
            title: const Text('Feedback'),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.question_mark_rounded,
                size: 20.0, color: Colors.white),
            title: const Text('FAQ'),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.settings, size: 20.0, color: Colors.white),
            title: const Text("Settings"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
