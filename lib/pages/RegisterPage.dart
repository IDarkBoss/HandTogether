/*
 * Created by 李卓原 on 2018/10/13.
 * email: zhuoyuan93@gmail.com
 * 写一个贼特么好看的登录页面
 */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            buildTitleLine(),
            SizedBox(height: 70.0),
            buildEmailTextField(),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            SizedBox(height: 60.0),
            SizedBox(height: 60.0),
            buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Align buildRegisterButton(BuildContext context) {
    String _result;
    _register(_email, _password) async {
      try {
        print('注册中');
        Response response;
        Dio dio = new Dio();
        String url = "http://106.14.166.71/register/$_email&$_password";
        response = await dio.get(url);
        if (response.statusCode == 200) {
          _result = response.data;
          if (_result == "注册成功") {
            Fluttertoast.showToast(msg: "注册成功");
            Navigator.pop(context);
          } else if (_result == "用户名已存在") {
            Fluttertoast.showToast(msg: "用户名已存在");
          }
        } else {
          _result = 'error code : ${response.statusCode}';
          Fluttertoast.showToast(msg: _result);
        }
      } catch (exception) {
        print('exc:$exception');
      }

      setState(() {});
    }

    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行注册方法
              _register(_email, _password);

              print('email:$_email , password:$_password');
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Emall Address',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的邮箱地址';
        }
      },
      onSaved: (String value) => _email = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Register',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
