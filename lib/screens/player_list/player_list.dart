import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Player.dart';
import 'package:roler_picker/storage/local_storage_player.dart';

import 'new_player.dart';

class PlayerListPage extends StatefulWidget {
  final LocalStoragePlayer storage;

  PlayerListPage({Key key, @required this.storage}) : super(key: key);

  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}



class _PlayerListPageState extends State<PlayerListPage> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Future<List<Player>> _playerList;
  int _highestId = 0;

  Future<List<Player>> awaitPlayerList() async {
    return await widget.storage.getPlayerList();
  }

  void refreshPlayerList() {
    setState(() {
      _playerList = awaitPlayerList();
    });
  }

  @override
  void initState() {
    super.initState();
    _playerList = awaitPlayerList();
    //widget.storage.writePlayerFile('[{"id":4,"name":"Test"},{"id":8,"name":"Test2"}]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child:
          FutureBuilder<List<Player>>(
            future: _playerList,
            builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                final resultPlayerList = snapshot.data;
                if (resultPlayerList.isNotEmpty) _highestId = resultPlayerList[resultPlayerList.length-1].id;
                    child = Center(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: resultPlayerList.length * 2,
                        itemBuilder: (BuildContext context, int index) {
                          if (index.isOdd) return Divider();

                          final i = index ~/ 2;
                          Player player = resultPlayerList[i];

                          return _buildRow(player, context);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPlayerPage(storage: widget.storage, id: _highestId+1)),
          ).then( (value) {
            refreshPlayerList();
          });
        },
        tooltip: 'Spieler hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRow(Player player, context) {
    return ListTile(
      title: Text(
        player.name,
        style: _biggerFont,
      ),
    );
  }
}
