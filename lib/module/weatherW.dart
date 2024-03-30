import 'package:flutter/material.dart';

import '../define_class/Weather/weather.dart';

Widget buildWeather(Weather weather, Size size) {
  // switch (weather.condition) {
  //   case 'Sunny':
  //     break;
  //   case 'Partly cloudy':
  //     break;
  //   case 'Overcast':
  //     break;
  //   case 'Rain':
  //     break;
  //   case 'Light rain':
  //     break;
  //   default:
  // }
  return Column(
    children: [
      // SvgPicture.asset(
      //   svg,
      //   height: size.height * 0.04,
      //   width: size.width * 0.04,
      //   color: Colors.red,
      // ),
      Row(
        children: <Widget>[
          Column(children: [
            Image.asset(
              'assets/icons/clouds.png',
              height: size.height * 0.035,
              width: size.width * 0.035,
            ),
            Row(
              children: [
                Text(
                  '${weather.tempC}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'oC',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ]),
          SizedBox(
            width: size.height * 0.05,
          ),
          Column(children: [
            Image.asset(
              'assets/icons/humidity.png',
              height: size.height * 0.035,
              width: size.width * 0.035,
            ),
            Row(
              children: [
                Text(
                  '${weather.humi}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  '%',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ]),
          SizedBox(
            width: size.height * 0.05,
          ),
          Column(children: [
            Image.asset(
              'assets/icons/windspeed.png',
              height: size.height * 0.035,
              width: size.width * 0.035,
            ),
            Row(
              children: [
                Text(
                  '${weather.wind}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'mph',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}
