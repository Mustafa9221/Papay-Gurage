import 'package:flutter/material.dart';
import 'package:papayadminpanel/screens/completed_screen.dart';
import 'package:papayadminpanel/screens/dashboard_screen.dart';
import 'package:papayadminpanel/screens/inRepair_screen.dart';
import 'package:papayadminpanel/screens/request_screen.dart';
import '../screens/home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    RequestScreen(),
    RepairScreen(),
    CompletedScreen(),
    DashboardScreen()
  ];

  final List<String> titles = [
    'Requests',
    'InRepair',
    'Complete',
    'Dashboard'
  ];

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(titles[selectedIndex],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            leading: isDesktop
                ? null
                : Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu,color: Colors.white,),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
          ),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: MenuList(
                    selectedIndex: selectedIndex,
                    onTap: (index) {
                      Navigator.pop(context);
                      onSelect(index);
                    },
                  ),
                ),
          body: Row(
            children: [
              if (isDesktop)
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 220,
                    color: Colors.lightGreen,
                    child: MenuList(
                      selectedIndex: selectedIndex,
                      onTap: onSelect,
                    ),
                  ),
                ),
              Expanded(child: screens[selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

class MenuList extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const MenuList({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ['Requests', 'InRepair', 'Completed',"Dashbord"];
    final icons = [Icons.request_page, Icons.car_repair, Icons.check,Icons.dashboard];

    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
        color: selectedIndex==index?Colors.white:Colors.transparent,
          borderRadius: BorderRadius.circular(8)
        ),
        child: ListTile(
          leading: Icon(icons[index],
              color: index == selectedIndex ? Colors.indigo : Colors.black54),
          title: Text(
            menuItems[index],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          selected: index == selectedIndex,
          onTap: () => onTap(index),
        ),
      ),
    );
  }
}



