import 'package:tuple/tuple.dart';

import 'Player.dart';
import 'Role.dart';
import 'dart:convert';

class Game {
  int id;
  String name;
  List<dynamic> tupleListJson;
  List<Tuple2<Player, Role>> tupleList;

  Game(this.id, this.name, this.tupleListJson);

  Game.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        tupleListJson = json['gameMap'],
        tupleList = new List() {

    tupleListJson.forEach((element) {
      Player player = Player.fromJson(element["player"]);
      Role role = Role.fromJson(element["role"]);
      Tuple2<Player, Role> tuple2 = new Tuple2(player, role);
      tupleList.add(tuple2);
    });

  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'game': {
          json.encode(tupleListJson)
        },
      };

}
