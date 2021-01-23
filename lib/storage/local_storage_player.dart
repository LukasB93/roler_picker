import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'Player.dart';

class LocalStoragePlayer {
  //List<User> _userList;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFilePlayer async {
    final path = await _localPath;
    return File('$path/player.json');
  }

  Future<String> readPlayerFile() async {
    try {
      final file = await _localFilePlayer;
      print("Reading from _localFilePlayer...");
      final String result = await file.readAsString();
      print("Read from _localFilePlayer: " + result);
      return result;
    } catch (e) {
      return "";
    }
  }

  Future<File> writePlayerFile(String playerJson) async {
    final file = await _localFilePlayer;
    print("Writing to _localFilePlayer: " + playerJson);
    return file.writeAsString(playerJson);
  }

  Future<bool> appendPlayerList(List<Player> playerList) async {
    String jsonString;
    print("Read _localFilePlayer File for appendPlayerList...");
    List<Player> existingPlayer = await getPlayerList();
    jsonString = "[";
    for(int i = 0; i < existingPlayer.length; i++) {
      Player user = existingPlayer[i];
      jsonString += json.encode(user.toJson());
      if (i+1 < existingPlayer.length) jsonString += ",";
    }
    if (existingPlayer.length > 0) jsonString += ",";
    for(int i = 0; i < playerList.length; i++) {
      Player user = playerList[i];
      jsonString += json.encode(user.toJson());
      if (i+1 < playerList.length) jsonString += ",";
    }
    jsonString += "]";
    bool success = (await this.writePlayerFile(jsonString)) != null;
    return success;
  }

  Future<List<Player>> getPlayerList() async {
    List<dynamic> localJsonList;
    List<Player> localPlayerList = List<Player>();

    print("Read _localFilePlayer for getPlayerList...");
    String result = await readPlayerFile();

    if (result != null && result != '') {
      localJsonList = json.decode(result);
      for (dynamic element in localJsonList) {
        Player player = Player.fromJson(element);
        localPlayerList.add(player);
      }
    }

    return localPlayerList;
  }
}