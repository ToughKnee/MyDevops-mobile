import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/paths.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Paths.home);
        break;
      case 1:
        context.go(Paths.search);
        break;
      case 2:
        context.go(Paths.create);
        break;
      case 3:
        context.go(Paths.notifications);
        break;
      case 4:
        context.go(Paths.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCR Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => context.push(Paths.settings),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => _onTap(context, i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}