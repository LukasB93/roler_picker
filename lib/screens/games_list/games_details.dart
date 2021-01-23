import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Game.dart';
import 'package:roler_picker/storage/Player.dart';
import 'package:roler_picker/storage/Role.dart';
import 'package:tuple/tuple.dart';

class GamesDetailsPage extends StatefulWidget {
  final Game _game;

  GamesDetailsPage(this._game, {Key key}) : super(key: key);

  @override
  _GamesDetailsPageState createState() => _GamesDetailsPageState();
}

class _GamesDetailsPageState extends State<GamesDetailsPage> {
  var _gameList = List<Tuple2<Player, Role>>();

  void initState() {
    super.initState();
    _gameList.addAll(widget._game.tupleList);
  }

  Widget buildPairRow(Tuple2<Player, Role> tuple) {
    var player = tuple.item1;
    var role = tuple.item2;

    return Row(
      children: [
        Text("Spielername: " + player.name),
        Text("Rollenname: " + role.name),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details zu " + widget._game.name),
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _gameList.length,
          itemBuilder: (BuildContext context, int index) {
            var tuple = _gameList[index];
            return buildPairRow(tuple);
          }
        ),
      ),
    );
  }
}
