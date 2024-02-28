import 'package:flutter/material.dart';

import 'Pages/Home_Page/home_main.dart';
import 'Pages/Profile_Page/profile_main.dart';
import 'Pages/page3.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PageViewDemo(),
  ));
}

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  State<PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _pageController = PageController();
  int selectedPage = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [buildPageView(), buildBottomNav()]),
    );
  }

  Widget buildPageView() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        children: [
          HomePage(),
          Page2(),
          ProfilePage(),
        ],
        onPageChanged: onPageChange,
      ),
    );
  }


  Widget buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedPage,
      items: [
        BottomNavigationBarItem(label: "HomePage", icon: Icon(Icons.pages)),
        BottomNavigationBarItem(label: "Page2", icon: Icon(Icons.pages)),
        BottomNavigationBarItem(label: "ProfilePage", icon: Icon(Icons.pages)),
      ],
      onTap: (int index) {
        _pageController.animateToPage(index,
            duration: Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}