import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Player.dart';
import 'package:roler_picker/storage/local_storage_player.dart';

class NewPlayerPage extends StatefulWidget {
  final LocalStoragePlayer storage;
  final int id;

  NewPlayerPage({Key key, @required this.storage, @required this.id}) : super(key: key);

  @override
  _NewPlayerPageState createState() => _NewPlayerPageState();
}

class _NewPlayerPageState extends State<NewPlayerPage> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuen Spieler hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 15),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onSubmitted: (String value) async {
                  List<Player> playerList = List<Player>();
                  playerList.add(Player(widget.id, value));
                  bool success = await widget.storage.appendPlayerList(playerList);
                  if (success) Navigator.pop(context);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Spielername',
                ),
              )
            ],
        )
      ),
    );
  }
}
