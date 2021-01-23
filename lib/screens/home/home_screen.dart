import 'package:flutter/material.dart';
import 'package:roler_picker/screens/games_list/games_list.dart';
import 'package:roler_picker/screens/player_list/player_list.dart';
import 'package:roler_picker/screens/roles_list/roles_list.dart';
import 'package:roler_picker/storage/local_storage_games.dart';
import 'package:roler_picker/storage/local_storage_player.dart';
import 'package:roler_picker/storage/local_storage_roles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final widgetOptions = [
    GamesListPage(storage: LocalStorageGames()),
    PlayerListPage(storage: LocalStoragePlayer()),
    RoleListPage(storage: LocalStorageRoles()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Role Picker'),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.weekend),
              label: 'Spiele',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Spieler',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.adb),
              label: 'Rollen',
          ),

        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
