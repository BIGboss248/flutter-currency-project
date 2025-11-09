import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainPage()),
    GoRoute(path: '/settings', builder: (context, state) => Contacts()),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 33, 243, 103),
          primary: const Color.fromARGB(255, 243, 128, 33),
          secondary: const Color.fromARGB(255, 127, 46, 134),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 33, 243, 103),
          primary: const Color.fromARGB(255, 243, 128, 33),
          secondary: const Color.fromARGB(255, 127, 46, 134),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      locale: const Locale("en", "US"),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        //leading: Text(
        //"Left side widget"), // The widget on the left side of the app bar
        //leadingWidth: 100, // The width of the leading widget
        automaticallyImplyLeading: true, // The back button to previous page
      ),
      bottomNavigationBar: NavigationBar(
        // List navigation destination and their icons
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        // Action to do when a destination is selected
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
          if (index == 0) {
            // Navigator.pushNamed(context, '/home');
            context.go('/');
          } else if (index == 1) {
            // Navigator.pushNamed(context, '/settings');
            context.go('/settings');
          }
        },
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Go to', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ListTile(
                  title: const Center(child: Text('Home')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  title: const Center(child: Text('Settings')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(),
    );
  }
}

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  int currentPage =
      0; //This is for implementing navigation bar remove if not needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), //tip use !appbar snippet to create app bar
      bottomNavigationBar: NavigationBar(
        // List navigation destination and their icons
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        // Action to do when a destination is selected
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
          if (index == 0) {
            // Navigator.pushNamed(context, '/home');
            context.go('/');
          } else if (index == 1) {
            // Navigator.pushNamed(context, '/settings');
            context.go('/settings');
          }
        },
      ), //tip use !navigation bar snippet to create navigation bar
      endDrawer: Drawer(),
      body: Column(),
    );
  }
}
