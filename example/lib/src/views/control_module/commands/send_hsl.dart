import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendHsl extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendHsl({super.key, required this.meshManagerApi});

  @override
  State<SendHsl> createState() => _SendHslState();
}

class _SendHslState extends State<SendHsl> {
  int? selectedElementAddress = 0xffff;

  HSLColor? selectedColor;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-generic-hsl-form'),
      title: const Text('Send a generic hsl set'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-generic-hsl-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.parse(text);
            });
          },
        ),
        ElevatedButton(
          child: const Text('Pick Color'),
          onPressed: selectedElementAddress != null
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor?.toColor() ?? Colors.white,
                            onColorChanged: (color) {
                              setState(() {
                                print('color changed to $color');
                                final hsl = HSLColor.fromColor(color);
                                selectedColor = hsl;
                              });
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              : null,
        ),
        TextButton(
          onPressed: selectedColor != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  debugPrint('send hsl color $selectedColor to $selectedElementAddress');
                  try {
                    await widget.meshManagerApi
                        .sendLightHsl(
                          selectedElementAddress!,
                          (0xFFFF * selectedColor!.lightness).toInt(),
                          0xFFFF * selectedColor!.hue ~/ 360,
                          (0xFFFF * selectedColor!.saturation).toInt(),
                          0,
                        )
                        .timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    print(e);
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send Color'),
        )
      ],
    );
  }
}
