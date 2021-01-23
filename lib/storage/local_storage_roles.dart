import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'Role.dart';

class LocalStorageRoles {
  //List<User> _userList;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileRoles async {
    final path = await _localPath;
    return File('$path/roles.json');
  }

  Future<String> readRolesFile() async {
    try {
      final file = await _localFileRoles;
      print("Reading from _localFileRoles...");
      final String result = await file.readAsString();
      print("Read from _localFileRoles: " + result);
      return result;
    } catch (e) {
      return "";
    }
  }

  Future<File> writeRolesFile(String rolesJson) async {
    final file = await _localFileRoles;
    print("Writing to _localFileRoles: " + rolesJson);
    return file.writeAsString(rolesJson);
  }

  Future<bool> appendRolesList(List<Role> rolesList) async {
    String jsonString;
    print("Read _localFileRoles File for appendRolesList...");
    List<Role> existingRoles = await getRolesList();
    jsonString = "[";
    for(int i = 0; i < existingRoles.length; i++) {
      Role role = existingRoles[i];
      jsonString += json.encode(role.toJson());
      if (i+1 < existingRoles.length) jsonString += ",";
    }
    if (existingRoles.length > 0) jsonString += ",";
    for(int i = 0; i < rolesList.length; i++) {
      Role role = rolesList[i];
      jsonString += json.encode(role.toJson());
      if (i+1 < rolesList.length) jsonString += ",";
    }
    jsonString += "]";
    bool success = (await this.writeRolesFile(jsonString)) != null;
    return success;
  }

  Future<List<Role>> getRolesList() async {
    List<dynamic> localJsonList;
    List<Role> localPlayerList = List<Role>();

    print("Read _localFileRoles for getRolesList...");
    String result = await readRolesFile();

    if (result != null && result != '') {
      localJsonList = json.decode(result);
      for (dynamic element in localJsonList) {
        Role role = Role.fromJson(element);
        localPlayerList.add(role);
      }
    }

    return localPlayerList;
  }
}