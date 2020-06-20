import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handtogether/database/DB_Helper.dart';
import 'package:handtogether/database/model.dart';

class ChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChartPageState();
  }
}

class _ChartPageState extends State<ChartPage> {
  List<HandUpDown> _datas = List();
  var db = DatabaseHelper();

  Future<Null> _refresh() async {
    _query();
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDb();
  }

  _getDataFromDb() async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //数据库有数据
      datas.forEach((handUpDown) {
        HandUpDown item = HandUpDown.fromMap(handUpDown);
        _datas.add(item);
      });
    }

    setState(() {});
  }

  //删除
  Future<Null> _delete(id) async {
    db.deleteItem(id);
    _query();
  }

  //修改
  Future<Null> _update(id) async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //修改第一条数据
      HandUpDown u = HandUpDown.fromMap(datas[0]);
      u.type = "我被修改了";
      db.updateItem(u);
      _query();
    }
  }

  //查询
  Future<Null> _query() async {
    _datas.clear();
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //数据库有数据
      datas.forEach((handUpDown) {
        HandUpDown dataListBean = HandUpDown.fromMap(handUpDown);
        _datas.add(dataListBean);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _datas.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key('key_${_datas[index]}'),
              background: Container(
                color: Colors.green,
                // 这里使用 ListTile 因为可以快速设置左右两端的Icon
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                // 这里使用 ListTile 因为可以快速设置左右两端的Icon
                child: ListTile(
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("次数：" + _datas[index].id.toString())),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("时间：" + _datas[index].time.toString())),
                ],
              ),
              onDismissed: (direction) {
                var _snackStr;
                if (direction == DismissDirection.endToStart) {
                  // 从右向左  也就是删除
                  _snackStr = '删除了${_datas[index].id}';
                  _delete(_datas[index].id);
                } else if (direction == DismissDirection.startToEnd) {
                  _snackStr = '收藏了${_datas[index].id}';
                }

                Fluttertoast.showToast(msg: _snackStr);

                setState(() {
                  _datas.removeAt(index);
                });
              },
              confirmDismiss: (direction) async {
                var _confirmContent;

                var _alertDialog;

                if (direction == DismissDirection.endToStart) {
                  // 从右向左  也就是删除
                  _confirmContent = '确认删除${_datas[index].id}？';
                  _alertDialog = _createDialog(
                    _confirmContent,
                    () {
                      // 展示 SnackBar
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('确认删除${_datas[index].id}'),
                        duration: Duration(milliseconds: 400),
                      ));
                      Navigator.of(context).pop(true);
                    },
                    () {
                      // 展示 SnackBar
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('不删除${_datas[index].id}'),
                        duration: Duration(milliseconds: 400),
                      ));
                      Navigator.of(context).pop(false);
                    },
                  );
                } else if (direction == DismissDirection.startToEnd) {
                  _confirmContent = '确认收藏${_datas[index].id}？';
                  _alertDialog = _createDialog(
                    _confirmContent,
                    () {
                      // 展示 SnackBar
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('确认收藏${_datas[index].id}'),
                        duration: Duration(milliseconds: 400),
                      ));
                      Navigator.of(context).pop(true);
                    },
                    () {
                      // 展示 SnackBar
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('不收藏${_datas[index].id}'),
                        duration: Duration(milliseconds: 400),
                      ));
                      Navigator.of(context).pop(false);
                    },
                  );
                }

                var isDismiss = await showDialog(
                    context: context,
                    builder: (context) {
                      return _alertDialog;
                    });
                return isDismiss;
              },
            );
          },
        ),
      ),
    );
  }

  Widget _createDialog(
      String _confirmContent, Function sureFunction, Function cancelFunction) {
    return AlertDialog(
      title: Text('Confirm'),
      content: Text(_confirmContent),
      actions: <Widget>[
        FlatButton(onPressed: sureFunction, child: Text('sure')),
        FlatButton(onPressed: cancelFunction, child: Text('cancel')),
      ],
    );
  }
}
