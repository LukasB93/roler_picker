import 'package:flutter/material.dart';
import 'package:roler_picker/storage/Role.dart';
import 'package:roler_picker/storage/local_storage_roles.dart';

import 'new_role.dart';

class RoleListPage extends StatefulWidget {
  final LocalStorageRoles storage;

  RoleListPage({Key key, @required this.storage}) : super(key: key);

  @override
  _RoleListPageState createState() => _RoleListPageState();
}



class _RoleListPageState extends State<RoleListPage> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  Future<List<Role>> _rolesList;
  int _highestId = 0;

  Future<List<Role>> awaitRoleList() async {
    return await widget.storage.getRolesList();
  }

  void refreshRoleList() {
    setState(() {
      _rolesList = awaitRoleList();
    });
  }

  @override
  void initState() {
    super.initState();
    _rolesList = awaitRoleList();
    //widget.storage.writeRolesFile('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
        FutureBuilder<List<Role>>(
          future: _rolesList,
          builder: (BuildContext context, AsyncSnapshot<List<Role>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              final resultRoleList = snapshot.data;
              if (resultRoleList.isNotEmpty) _highestId = resultRoleList[resultRoleList.length-1].id;
              child = Center(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: resultRoleList.length * 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isOdd) return Divider();

                    final i = index ~/ 2;
                    Role role = resultRoleList[i];

                    return _buildRow(role, context);
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
            MaterialPageRoute(builder: (context) => NewRolePage(storage: widget.storage, id: _highestId+1)),
          ).then( (value) {
            refreshRoleList();
          });
        },
        tooltip: 'Spieler hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRow(Role role, context) {
    return ListTile(
      title: Text(
        role.name,
        style: _biggerFont,
      ),
    );
  }
}
