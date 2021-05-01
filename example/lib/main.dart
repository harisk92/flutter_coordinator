import 'package:coordinator/coordinator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CoordinatorRoot(
      routerDelegate: CoordinatorRouterDelegate(
        initialLocation: HomeLocation(),
        routes: [
          CoordinatorRoute<HomeLocation>(
            path: "/home",
            screenBuilder: (context, _) => TabScreen(),
            locationBuilder: (params) => HomeLocation(),
          ),
        ],
      ),
      builder: (context, delegate) => MaterialApp.router(
        routeInformationParser: CoordinatorRouteInformationParser(),
        routerDelegate: delegate,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class FirstScreenLocation extends BasicLocation {
  @override
  String uniqueKey = "firstScreenLocation";
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Coordinator.of(context).push(SecondScreenLocation()),
          child: Text("Go to second screen"),
        ),
      ),
    );
  }
}

class SecondScreenLocation extends BasicLocation {
  @override
  String uniqueKey = "secondScreenLocation";
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Welcome to screen two"),
      ),
    );
  }
}

class HomeLocation extends BasicLocation {
  @override
  String uniqueKey = "home";
}

class TabScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final bottomBarIndex = useState(0);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomBarIndex.value,
        onTap: (index) {
          tabController.index = index;
          bottomBarIndex.value = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: "Flights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_transit),
            label: "Schedule",
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Coordinator(
            name: "Flights",
            initialLocation: FirstScreenLocation(),
            routes: [
              CoordinatorRoute<FirstScreenLocation>(
                path: "/first",
                screenBuilder: (context, _) => FirstScreen(),
                locationBuilder: (params) => FirstScreenLocation(),
              ),
              CoordinatorRoute<SecondScreenLocation>(
                path: "/second_screen",
                screenBuilder: (context, _) => SecondScreen(),
                locationBuilder: (params) => SecondScreenLocation(),
              ),
            ],
          ),
          Coordinator(
            name: "Schedule",
            initialLocation: FirstScreenLocation(),
            routes: [
              CoordinatorRoute<FirstScreenLocation>(
                path: "/first",
                screenBuilder: (context, _) => FirstScreen(),
                locationBuilder: (params) => FirstScreenLocation(),
              ),
              CoordinatorRoute<SecondScreenLocation>(
                path: "/second_screen",
                screenBuilder: (context, _) => SecondScreen(),
                locationBuilder: (params) => SecondScreenLocation(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
