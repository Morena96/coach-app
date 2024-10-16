import 'package:coach_app/l10n.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:flutter/material.dart';

class AntennaListItem extends StatelessWidget {
  const AntennaListItem({
    super.key,
    required this.antenna,
    required this.index,
  });
  final AntennaInfo antenna;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.antenna(index + 1)),
      children: [
        ListTile(title: Text(context.l10n.port(antenna.portName))),
        ListTile(
          title: Text(('${context.l10n.description}: ${antenna.description}')),
        ),
        ListTile(title: Text(context.l10n.serialNumber(antenna.serialNumber))),
      ],
    );
  }
}
