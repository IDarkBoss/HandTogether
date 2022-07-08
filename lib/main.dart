import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handtogether/pages/CalendarPage.dart';
import 'package:handtogether/pages/ChartPage.dart';
import 'package:handtogether/pages/HomePage.dart';
import 'package:handtogether/pages/MyPage.dart';
import 'package:handtogether/pages/NewPage.dart';

import 'frameworks/MyDrawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "全民手冲",
      theme: ThemeData(
          primarySwatch: Colors.lightBlue //primarySwatch ：现在支持18种主题样本。
          ),
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<_Home> {
  DateTime _lastTime;

  Future<bool> _isExit() {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime) > Duration(milliseconds: 2500)) {
      _lastTime = DateTime.now();
      Fluttertoast.showToast(msg: "再次点击退出应用");
      return Future.value(false);
    }
    return Future.value(true);
  }

  int _index = 0; //数组索引，通过改变索引值改变视图
  static const HomePageImgUrls = [
    'assets/icons/HomePage.png',
    'assets/icons/HomePage-red.png',
  ];
  static const CalendarImgUrls = [
    'assets/icons/calendar.png',
    'assets/icons/calendar-red.png',
  ];
  static const ChartImgUrls = [
    'assets/icons/chart.png',
    'assets/icons/chart-red.png',
  ];
  static const MineImgUrls = [
    'assets/icons/Mine.png',
    'assets/icons/Mine-red.png',
  ];

  var _pages;
  String home = HomePageImgUrls[0];
  String calendar = CalendarImgUrls[0];
  String chart = ChartImgUrls[0];
  String mine = MineImgUrls[0];

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), CalendarPage(), ChartPage(), MyPage()];
  }

  _openNewPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return EachView("NewPage");
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (_index == 0) {
      home = HomePageImgUrls[1];
      calendar = CalendarImgUrls[0];
      chart = ChartImgUrls[0];
      mine = MineImgUrls[0];
    } else if (_index == 1) {
      home = HomePageImgUrls[0];
      calendar = CalendarImgUrls[1];
      chart = ChartImgUrls[0];
      mine = MineImgUrls[0];
    } else if (_index == 2) {
      home = HomePageImgUrls[0];
      calendar = CalendarImgUrls[0];
      chart = ChartImgUrls[1];
      mine = MineImgUrls[0];
    } else if (_index == 3) {
      home = HomePageImgUrls[0];
      calendar = CalendarImgUrls[0];
      chart = ChartImgUrls[0];
      mine = MineImgUrls[1];
    }

    return WillPopScope(
      onWillPop: _isExit,
      child: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle,
          child: Scaffold(
            appBar: AppBar(
              title: Text("全民☕"),
            ),
            drawer: MyDrawer(),
            floatingActionButton: FloatingActionButton(
                onPressed: _openNewPage,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            //和底栏进行融合
            bottomNavigationBar: _bottomAppBar(),
            body: _pages[_index],
          )),
    );
  }

  Widget _bottomAppBar() {
    double itemWidth = MediaQuery.of(context).size.width / 5;

    return BottomAppBar(
      color: Colors.lightBlue, //底部工具栏的颜色。
      shape: CircularNotchedRectangle(),
      //设置底栏的形状，一般使用这个都是为了和floatingActionButton融合，
      // 所以使用的值都是CircularNotchedRectangle(),有缺口的圆形矩形。
      child: Row(
        //里边可以放置大部分Widget，让我们随心所欲的设计底栏
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: itemWidth,
            child: IconButton(
              icon: Image.asset(home),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
            ),
          ),
          SizedBox(
            width: itemWidth,
            child: IconButton(
              icon: Image.asset(calendar),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _index = 1;
                });
              },
            ),
          ),
          SizedBox(width: itemWidth),
          SizedBox(
            width: itemWidth,
            child: IconButton(
              icon: Image.asset(chart),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _index = 2;
                });
              },
            ),
          ),
          SizedBox(
            width: itemWidth,
            child: IconButton(
              icon: Image.asset(mine),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _index = 3;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

//子页面
//代码中设置了一个内部的_title变量，这个变量是从主页面传递过来的，然后根据传递过来的具体值显示在APP的标题栏和屏幕中间。
class EachView extends StatefulWidget {
  String _title;

  EachView(this._title);

  @override
  _EachViewState createState() => _EachViewState();
}

class _EachViewState extends State<EachView> {
  @override
  Widget build(BuildContext context) {
    return NewPage();
  }
}
