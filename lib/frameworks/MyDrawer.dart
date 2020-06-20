import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 80,
                  ),
                  Text(
                    "沙雕群友",
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("日历"),
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text("分类"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
          ),
        ],
      ),
    );
  }
}
