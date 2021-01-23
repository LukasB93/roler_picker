import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Role.dart';
import 'package:roler_picker/storage/local_storage_roles.dart';

class NewRolePage extends StatefulWidget {
  final LocalStorageRoles storage;
  final int id;

  NewRolePage({Key key, @required this.storage, @required this.id}) : super(key: key);

  @override
  _NewRolePageState createState() => _NewRolePageState();
}

class _NewRolePageState extends State<NewRolePage> {
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
        title: Text('Neue Rolle hinzufügen'),
      ),
      body: Padding(
          padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 15),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onSubmitted: (String value) async {
                  List<Role> rolesList = List<Role>();
                  rolesList.add(Role(widget.id, value));
                  bool success = await widget.storage.appendRolesList(rolesList);
                  if (success) Navigator.pop(context);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rollenname',
                ),
              )
            ],
          )
      ),
    );
  }
}
