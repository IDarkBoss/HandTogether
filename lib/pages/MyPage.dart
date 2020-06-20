import 'package:flutter/material.dart';
import 'package:handtogether/pages/LoginPage.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _islogined = 0;

    _islogin() {
      print("object");
      if (_islogined == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlue),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: _islogin, child: Icon(Icons.person)),
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
        ),
      ),
    );
  }
}
