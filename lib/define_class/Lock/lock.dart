class Lock {
  Status status;
  int id;
  String name;
  String typeDevice;
  // String room;

  Lock(this.status, this.id, this.name, this.typeDevice);

  factory Lock.fromJson(Map<String, dynamic> json) => Lock(
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
  bool button;
  bool state;

  Status(this.button, this.state);

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(json['button'], json['state']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['button'] = button;
    data['state'] = state;
    return data;
  }
}
