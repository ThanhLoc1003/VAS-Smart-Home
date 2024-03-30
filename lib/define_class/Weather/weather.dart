class Weather {
  // final double tempC;
  // final String condition;
  // final int humi;
  // final double wind;

  // Weather(
  //     {this.condition = "Sunny",
  //     this.humi = 0,
  //     this.tempC = 0.0,
  //     this.wind = 0.0});

  // factory Weather.fromJson(Map<String, dynamic> json) {
  //   return Weather(
  //       tempC: json['main']['feels_like'],
  //       humi: json['main']['humidity'],
  //       condition: json['weather']['description'],
  //       wind: json['wind']['speed']);
  // }
  String? cityName;
  double? tempC;
  double? wind;
  int? humi;
  double? feels_like;
  int? pressure;
  // List<Weather> weather;
  int? clouds;
  String? icon;
  Weather(
      {this.cityName,
      this.feels_like,
      this.humi,
      this.pressure,
      this.tempC,
      this.wind,
      this.clouds,
      this.icon});
  // factory ValueSensor.fromJson(Map<String, dynamic> json) {
  //   // Kiểm tra nếu json['temp1'] là kiểu int, thì chuyển đổi thành double
  //   final temp1Value = json['temp1'];
  //   final t1 = (temp1Value is int) ? temp1Value.toDouble() : temp1Value ?? 0.0;
  //   final temp2Value = json['temp2'];
  //   final t2 = (temp2Value is int) ? temp2Value.toDouble() : temp2Value ?? 0.0;
  //   final humid1Value = json['humid1'];
  //   final h1 =
  //       (humid1Value is int) ? humid1Value.toDouble() : humid1Value ?? 0.0;
  //   final humid2Value = json['humid2'];
  //   final h2 =
  //       (humid2Value is int) ? humid2Value.toDouble() : humid2Value ?? 0.0;
  //   return ValueSensor(t1, t2, h1, h2);
  // }

  factory Weather.fromJson(Map<String, dynamic> json) {
    final cityName = json["name"];
    final tempText = json["main"]["temp"];
    final temp = tempText.toDouble();
    final windText = json["wind"]["speed"];
    final wind = windText.toDouble();
    final humiText = json["main"]["humidity"];
    final humi = humiText.toInt();
    final pressure = json["main"]["pressure"];
    final feels_like = json["main"]["feels_like"];
    final clouds = json["clouds"]["all"];
    final icon = json["weather"][0]["icon"];
    // final weather = (json['weather'] as List<dynamic>)
    //     .map((e) => Weather.fromJson(e as Map<String, dynamic>))
    //     .toList();
    return Weather(
        cityName: cityName,
        clouds: clouds,
        tempC: temp,
        wind: wind,
        humi: humi,
        pressure: pressure,
        feels_like: feels_like,
        icon: icon);
  }
}
