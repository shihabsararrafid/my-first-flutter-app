import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: sidebar(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favourites = <WordPair>[];
  void getNext() {
    current = WordPair.random();
    print(current);
    notifyListeners();
  }

  void toggleFavourites() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }
    notifyListeners();
  }
}

class sidebar extends StatefulWidget {
  @override
  State<sidebar> createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MyHomePage();
        break;

      case 1:
        page = Favourites();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  var sidebar;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('A random word generator: '),
          bigCard(pair: pair),
          // adding a button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourites();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                      // print('Button Pressed');
                    },
                    child: Text("Next")),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class bigCard extends StatelessWidget {
  const bigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asCamelCase,
          style: style,
        ),
      ),
    );
  }
}

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favourites.isEmpty) {
      return Center(
        child: Text("No favourites added"),
      );
    }
    return Center(
      child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'You have added ${appState.favourites.length} favourites')),
          for (var pair in appState.favourites)
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(pair.asLowerCase),
            )
        ],
      ),
    );
  }
}
