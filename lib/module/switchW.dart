import 'package:flutter/material.dart';

import '../common_widget/custom_card.dart';
import '../constants.dart';
import '../define_class/Switch/switchC.dart';

// ignore: camel_case_types, must_be_immutable
class buildSwitch extends StatelessWidget {
  buildSwitch(
      {super.key, required this.size, required this.dev, required this.index});
  Size size;
  SwitchC dev;
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.17,
      width: size.width * 0.7,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.015),
            Row(
              children: [
                SizedBox(width: size.width * 0.01),
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
            SizedBox(height: size.height * 0.01),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: 'Button1',
                  state: dev.status.button1,
                  value: 0,
                  type: dev.typeDevice,
                  index: index,
                ),
                const SizedBox(width: 10),
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: 'Button2',
                  state: dev.status.button2,
                  value: 0,
                  type: dev.typeDevice,
                  index: index,
                ),
                const SizedBox(width: 10),
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: 'All',
                  state: dev.status.button1 && dev.status.button2,
                  value: 0,
                  type: dev.typeDevice,
                  index: index,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
