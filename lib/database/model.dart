class HandUpDown {
  int id;
  String type;
  String time;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['type'] = type;
    map['time'] = time;
    return map;
  }

  static HandUpDown fromMap(Map<String, dynamic> map) {
    HandUpDown handUpDown = HandUpDown();
    handUpDown.id = map['id'];
    handUpDown.type = map['type'];
    handUpDown.time = map['time'];
    return handUpDown;
  }

  static List<HandUpDown> fromMapList(dynamic mapList) {
    List<HandUpDown> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
