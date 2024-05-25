// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'historypage.dart';
import 'favoritepage.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <String>[];
  var history = <WordPair>[];
  var history1 = <String>[]; // 用于存储输入的内容
  var history2 = <String>[]; // 用于存储历史记录

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState
        as AnimatedListState?; //?表示如果historyListKey?.currentState为null，则返回null
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite(String pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(String value) {
    favorites.remove(value);
    notifyListeners();
  }

  void removeHistory(String value) {
    history2.remove(value);
    notifyListeners();
  }

  void storeThing(String value) {
    history1.insert(0, value);
    notifyListeners();
  }

  void storeHistory(String value) {
    history2.insert(0, value);
    history1.remove(value);
    notifyListeners();
  }

  void recoverHistory(String value) {
    history1.insert(0, value);
    history2.remove(value);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = HistoryPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: 'history',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'favorite',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('history'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('favorite'),
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
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  List<Widget> toDoItems = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'To Do list',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                for (var value in appState.history1) ToDoItem(pair: value),
              ],
            ),
          ),
          InputItem(),
        ],
      ),
    );
  }
}

class InputItem extends StatefulWidget {
  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  var content = '';
  final myController = TextEditingController();

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   myController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.primary, fontSize: 14);
    AutomaticKeepAliveClientMixin;

    return Card(
      color: theme.colorScheme.surface,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: SizedBox(
              child: TextField(
                controller: myController,
                onChanged: (value) {
                  print("Text field value: $value");
                  content = value;
                  //appState.storeThing(value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '',
                ),
                style: style,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add, semanticLabel: 'Add'),
              color: theme.colorScheme.primary,
              onPressed: () {
                if (content != '') {
                  appState.storeThing(content);
                  myController.clear();
                } else {
                  print("add empty!");
                }
                content = '';
              },
            ),
          )),
    );
  }
}

class ToDoItem extends StatelessWidget {
  const ToDoItem({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final String pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 25,
    );
    var appState = context.watch<MyAppState>();

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Card(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: IconButton(
            onPressed: () {
              appState.toggleFavorite(pair);
            },
            icon: Icon(icon),
          ),
          title: SizedBox(
            child: Text(
              pair,
              style: style,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.delete_outlined, semanticLabel: 'Delete'),
              color: theme.colorScheme.primary,
              onPressed: () {
                appState.storeHistory(pair);
                appState.removeFavorite(pair);
              }),
        ),
      ),
    );
  }
}
