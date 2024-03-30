import 'package:flutter/material.dart';
import '../define_class/Aircon/aircon.dart';
import '../common_widget/custom_card.dart';
import '../constants.dart';

// ignore: must_be_immutable
class BuildAircon extends StatelessWidget {
  BuildAircon(
      {super.key, required this.size, required this.index, required this.dev});
  Size size;
  Aircon dev;
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.27, //0.238,
      width: size.width * 0.72,
      decoration: BoxDecoration(
        color: kBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 0,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Padding(
        padding: const EdgeInsets.all(.0),
        child: Wrap(
          runSpacing: 5,
          alignment: WrapAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  dev.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            CustomCard(
                icon: Icons.power_settings_new,
                title: 'Power',
                state: dev.status.on,
                value: 0,
                index: index,
                type: dev.typeDevice),
            CustomCard(
                icon: Icons.swipe_right_rounded,
                title: 'Swing',
                index: index,
                state: dev.status.swing,
                value: 0,
                type: dev.typeDevice),
            CustomCard(
                icon: Icons.speed_rounded,
                title: 'FanSpeed',
                index: index,
                state: false,
                value: dev.status.fanSpeed,
                type: dev.typeDevice),
            CustomCard(
                icon: Icons.mode_standby_outlined,
                title: 'Mode',
                index: index,
                state: false,
                value: dev.status.mode,
                type: dev.typeDevice),
            const SizedBox(width: 10),
            CustomCard(
                icon: Icons.thermostat_outlined,
                title: 'Temp',
                index: index,
                state: false,
                value: dev.status.temp,
                type: dev.typeDevice),
          ],
        ),
      ),
    );
  }
}
