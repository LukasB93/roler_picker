import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'Game.dart';

class LocalStorageGames {
  //List<User> _userList;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileGames async {
    final path = await _localPath;
    return File('$path/games.json');
  }

  Future<String> readGamesFile() async {
    try {
      final file = await _localFileGames;
      print("Reading from _localFileGames...");
      final String result = await file.readAsString();
      print("Read from _localFileGames: " + result);
      return result;
    } catch (e) {
      return "";
    }
  }

  Future<File> writeGamesFile(String gamesJson) async {
    final file = await _localFileGames;
    print("Writing to _localFileGames: " + gamesJson);
    return file.writeAsString(gamesJson);
  }

  Future<bool> appendGamesList(List<Game> gamesList) async {
    String jsonString;
    print("Read _localFileGames File for appendGamesList...");
    List<Game> existingGames = await getGamesList();
    jsonString = "[";
    for(int i = 0; i < existingGames.length; i++) {
      Game game = existingGames[i];
      jsonString += json.encode(game.toJson());
      if (i+1 < existingGames.length) jsonString += ",";
    }
    if (existingGames.length > 0) jsonString += ",";
    for(int i = 0; i < gamesList.length; i++) {
      Game game = gamesList[i];
      jsonString += json.encode(game.toJson());
      if (i+1 < gamesList.length) jsonString += ",";
    }
    jsonString += "]";
    bool success = (await this.writeGamesFile(jsonString)) != null;
    return success;
  }

  Future<List<Game>> getGamesList() async {
    List<dynamic> localJsonList;
    List<Game> localGamesList = List<Game>();

    print("Read _localFileGames for getGamesList...");
    String result = await readGamesFile();

    if (result != null && result != '') {
      localJsonList = json.decode(result);
      for (dynamic element in localJsonList) {
        Game game = Game.fromJson(element);
        localGamesList.add(game);
      }
    }

    return localGamesList;
  }
}