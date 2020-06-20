import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handtogether/database/DB_Helper.dart';
import 'package:handtogether/src/flutter_datetime_picker.dart';

class NewPage extends StatefulWidget {
  NewPage({Key key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final TextEditingController _controller = TextEditingController();
  var selectedTime;
  var type = "handup_down";

  Future<Null> _add(type, time) async {
    if (time == null) {
      Fluttertoast.showToast(msg: "请选择日期");
    } else {
      await DatabaseHelper().saveItem(type, time);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("添加记录")),
      body: Container(
          child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              DatePicker.showDateTimePicker(context, showTitleActions: true,
                  onConfirm: (date) {
                selectedTime = date.toString();
                selectedTime =
                    selectedTime.substring(0, selectedTime.length - 7);
                _controller.text = selectedTime;
              }, currentTime: DateTime.now(), locale: LocaleType.zh);
            },
            child: Icon(Icons.calendar_today),
          ),
          Expanded(
              child: TextField(
            readOnly: true,
            controller: _controller,
          )),
          FlatButton(onPressed: null, child: null),

          // TextField(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(type, selectedTime),
        child: Icon(Icons.add),
      ),
    );
  }
}
