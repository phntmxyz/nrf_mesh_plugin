import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendLightnessLevel extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendLightnessLevel({super.key, required this.meshManagerApi});

  @override
  State<SendLightnessLevel> createState() => _SendLightnessLevelState();
}

class _SendLightnessLevelState extends State<SendLightnessLevel> {
  int? selectedElementAddress = 0xffff;

  int? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-generic-lightness-form'),
      title: const Text('Send a generic lightness set'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-generic-lightness-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.tryParse(text);
          },
        ),
        TextField(
          key: const ValueKey('module-send-generic-lightness-value'),
          decoration: const InputDecoration(hintText: 'Lightness Value'),
          onChanged: (text) {
            setState(() {
              selectedLevel = int.tryParse(text);
            });
          },
        ),
        TextButton(
          onPressed: selectedLevel != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  debugPrint('send level $selectedLevel to $selectedElementAddress');
                  try {
                    await widget.meshManagerApi
                        .sendLightLightness(selectedElementAddress!, selectedLevel!, 0)
                        .timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send level'),
        )
      ],
    );
  }
}
