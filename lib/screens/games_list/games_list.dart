import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Game.dart';
import 'package:roler_picker/storage/local_storage_games.dart';

import 'games_details.dart';

class GamesListPage extends StatefulWidget {
  final LocalStorageGames storage;

  GamesListPage({Key key, @required this.storage}) : super(key: key);

  @override
  _GamesListPageState createState() => _GamesListPageState();
}



class _GamesListPageState extends State<GamesListPage> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Future<List<Game>> _gamesList;
  int _highestId = 0;

  Future<List<Game>> awaitGamesList() async {
    return await widget.storage.getGamesList();
  }

  void refreshGamesList() {
    setState(() {
      _gamesList = awaitGamesList();
    });
  }

  @override
  void initState() {
    super.initState();
    _gamesList = awaitGamesList();
    widget.storage.writeGamesFile('[{"id":4,"name":"Spiel 1","gameMap":[{"player":{"id":1,"name":"Alice"},"role":{"id":1,"name":"Rolle 1"}},{"player":{"id":2,"name":"Bob"},"role":{"id":1,"name":"Rolle 2"}}]},{"id":4,"name":"Spiel 2","gameMap":[{"player":{"id":1,"name":"Alice"},"role":{"id":1,"name":"Rolle 2"}},{"player":{"id":2,"name":"Bob"},"role":{"id":1,"name":"Rolle 1"}}]}]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
        FutureBuilder<List<Game>>(
          future: _gamesList,
          builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              final resultGamesList = snapshot.data;
              if (resultGamesList.isNotEmpty) _highestId = resultGamesList[resultGamesList.length-1].id;
              child = Center(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: resultGamesList.length * 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isOdd) return Divider();

                    final i = index ~/ 2;
                    Game game = resultGamesList[i];

                    return _buildRow(game, context);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              child = Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
              child = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60)],
                  )
              );
            } else {
              child = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    )],
                  )
              );
            }
            return child;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Spiel erstellen',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRow(Game game, context) {
    return ListTile(
      title: Text(
        game.name,
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => GamesDetailsPage(game)),
        );
      },
    );
  }
}
