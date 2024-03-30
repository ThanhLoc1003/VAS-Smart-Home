import 'package:flutter/material.dart';

import '../common_widget/custom_card.dart';
import '../constants.dart';
import '../define_class/Induction/induction.dart';

// ignore: must_be_immutable
class BuildInduction extends StatelessWidget {
  BuildInduction({super.key, required this.size, required this.dev});
  Size size;
  Induction dev;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.17, //0.238,
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
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.01),
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
            SizedBox(height: size.height * 0.01),
            Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                CustomCard(
                    icon: Icons.power_settings_new,
                    title: 'Power',
                    state: dev.status.power,
                    value: 0,
                    index: 0,
                    type: dev.typeDevice),
                const SizedBox(width: 10),
                CustomCard(
                    icon: Icons.settings_power_outlined,
                    title: 'Level',
                    state: false,
                    value: dev.status.powerLevel,
                    index: 0,
                    type: dev.typeDevice),
                const SizedBox(width: 10),
                CustomCard(
                    icon: Icons.gas_meter_outlined,
                    title: 'Cooking',
                    state: dev.status.cooking,
                    value: 0,
                    index: 0,
                    type: dev.typeDevice),
                const SizedBox(width: 10),
                CustomCard(
                    icon: Icons.straighten_outlined,
                    title: 'Stirfry',
                    state: dev.status.stirfry,
                    value: 0,
                    index: 0,
                    type: dev.typeDevice),
                const SizedBox(width: 10),
                CustomCard(
                    icon: Icons.timer,
                    title: 'Timer',
                    state: dev.status.stirfry,
                    value: dev.status.timer,
                    index: 0,
                    type: dev.typeDevice),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
