class RolldoorC {
  Status status;
  int id;
  String name;
  String typeDevice;
  // String room;

  RolldoorC(this.status, this.id, this.name, this.typeDevice);

  factory RolldoorC.fromJson(Map<String, dynamic> json) => RolldoorC(
        Status.fromJson(json['status']),
        json['_id'] as int,
        json['name'] as String,
        json['typeDevice'] as String,
        // json['room'] as String
      );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status.toJson();
    data['_id'] = id;
    data['name'] = name;
    data['typeDevice'] = typeDevice;
    // data['room'] = room;

    return data;
  }
}

class Status {
  bool button1;
  bool button2;

  Status(this.button1, this.button2);

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(json['button1'], json['button2']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['button1'] = button1;
    data['button2'] = button2;
    return data;
  }
}
