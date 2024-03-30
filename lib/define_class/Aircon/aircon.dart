class Aircon {
  int id;
  String name;
  String typeDevice;
  Status status;
  // String room;

  Aircon(this.id, this.name, this.typeDevice, this.status);

  factory Aircon.fromJson(Map<String, dynamic> json) => Aircon(
      json['_id'] as int,
      json['name'] as String,
      json['typeDevice'] as String,
      Status.fromJson(json['status'])
      // json['room'] as String
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['typeDevice'] = typeDevice;
    data['status'] = status.toJson();
    // data['room'] = room;
    return data;
  }
}

class Status {
  bool on;
  String brand;
  int mode;
  int fanSpeed;
  int temp;
  // int tempRoom;
  // int humid;
  bool swing;

  Status(this.on, this.brand, this.mode, this.fanSpeed, this.temp, this.swing);

  factory Status.fromJson(Map<String, dynamic> json) => Status(
      json['on'] as bool,
      json['brand'] as String,
      json['mode'] as int,
      json['fanSpeed'] as int,
      json['temp'] as int,
      // json['temp_room'] as int,
      // json['humid'] as int,
      json['swing'] as bool);
  //  {
  //   on = json['on'];
  //   brand = json['brand'];
  //   mode = json['mode'];
  //   fanSpeed = json['fanSpeed'];
  //   temp = json['temp'];
  //   tempRoom = json['temp_room'];
  //   humid = json['humid'];
  //   swing = json['swing'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['on'] = on;
    data['brand'] = brand;
    data['mode'] = mode;
    data['fanSpeed'] = fanSpeed;
    data['temp'] = temp;
    // data['temp_room'] = tempRoom;
    // data['humid'] = humid;
    data['swing'] = swing;
    return data;
  }
}
