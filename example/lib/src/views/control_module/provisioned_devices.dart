import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/app.dart';
import 'package:nordic_nrf_mesh_example/src/mesh_manager_provider.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/module.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/device.dart';
import 'package:provider/provider.dart';

class ProvisionedDevices extends StatefulWidget {
  const ProvisionedDevices({Key? key}) : super(key: key);

  @override
  State<ProvisionedDevices> createState() => _ProvisionedDevicesState();
}

class _ProvisionedDevicesState extends State<ProvisionedDevices> {
  final _devices = <DiscoveredDevice>{};
  bool isScanning = false;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  DiscoveredDevice? _device;

  @override
  void initState() {
    super.initState();
    _scanProvisionned(context);
  }

  @override
  void dispose() {
    super.dispose();
    _scanSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isScanning) const LinearProgressIndicator(),
        if (_device == null) ...[
          if (!isScanning && _devices.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No module found'),
              ),
            ),
          if (_devices.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  for (var i = 0; i < _devices.length; i++)
                    Device(
                      key: ValueKey('device-$i'),
                      device: _devices.elementAt(i),
                      onTap: () {
                        setState(() {
                          _device = _devices.elementAt(i);
                        });
                      },
                    ),
                ],
              ),
            ),
        ] else
          Expanded(
            child: Module(
                device: _device!,
                onDisconnect: () {
                  _device = null;
                  _scanProvisionned(context);
                }),
          ),
      ],
    );
  }

  Future<void> _scanProvisionned(BuildContext context) async {
    final nordicNrfMesh = context.read<MeshManagerNotifier>().mesh;
    setState(() {
      _devices.clear();
    });
    await checkAndAskPermissions();
    _scanSubscription = nordicNrfMesh.scanForProxy().listen((device) async {
      if (_devices.every((d) => d.id != device.id)) {
        setState(() {
          _devices.add(device);
        });
      }
    });
    setState(() {
      isScanning = true;
    });
    return Future.delayed(const Duration(seconds: 10), _stopScan);
  }

  Future<void> _stopScan() async {
    await _scanSubscription?.cancel();
    isScanning = false;
    if (mounted) {
      setState(() {});
    }
  }
}
