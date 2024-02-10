import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:test_app1/_encrypt.dart';
import 'package:test_app1/_network.dart';
import 'package:test_app1/_nfc.dart';
import 'package:test_app1/_permission.dart';
import 'package:test_app1/_qr_code.dart';





void main() {
  runApp(MyApp());
}

//app itself is a widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Test App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade100),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random(); //reassigns the current with a new random workPair
    notifyListeners();
  }

  //new property to app state
  var favourites = <WordPair>[];

  void toggleFavorite(){
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }
    notifyListeners();      
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//underscore makes the class private
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex=0; //establishing state



  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
       
      case 1:
        page = LikePage();
        
      case 2:
        page = GenerateQRCode();

      case 3:
        page = QRCodeScannerApp();

      case 4:
        page = Network();

      case 5:
        page = Encrypt();

      case 6:
        page = PermissionHandlerWidget();

      case 7:
        page = NFC();
      
      default:
        throw UnimplementedError('no widget for $selectedIndex');
      

    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >=600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.qr_code),
                      label: Text('Generate QR'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.qr_code_scanner),
                      label: Text('Scan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.network_cell),
                      label: Text('Http'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.enhanced_encryption),
                      label: Text('Encrypt'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.analytics),
                      label: Text('Permission'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.nfc),
                      label: Text('NFC'),
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
    );
  }
}


class GeneratorPage extends StatelessWidget {
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
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    var appState= context.watch<MyAppState>();

    if (appState.favourites.isEmpty){
      return Center(
        child: Text('No favorites yet :('),
      );
    }

    return ListView(
      children: [
        Padding(
          padding:const EdgeInsets.all(20) ,
          child: Text ('You have '
          '${appState.favourites.length} favourites:'),
          ),
          for (var pair in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asSnakeCase),
          )
      ]
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
       color: theme.colorScheme.onPrimary,
       
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asSnakeCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}




class QRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    var appState= context.watch<MyAppState>();


    return ListView(
      children: [
        Padding(
          padding:const EdgeInsets.all(20) ,
          child: Text ('You have '
          '${appState.favourites.length} favourites:'),
          ),
          for (var pair in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asSnakeCase),
          )
      ]
    );
  }
}