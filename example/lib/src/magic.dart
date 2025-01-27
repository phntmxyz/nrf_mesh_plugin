import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/mesh_manager_provider.dart';

const String networkKey = '183D762D54BB20870F0972DE1793BF96';
const String appKey = '664AC10D4DFCE019553AC2D99FF9E79B';
const String deviceKey = '664AC10D4DFCE019553AC2D99FF9E79B';

class Magic extends ChangeNotifier {
  Magic(this.meshManager);

  final MeshManagerNotifier meshManager;

  int _counter = 0;

  int get counter => _counter;

  Future<bool> connectNetwork() async {
    final network = await meshManager.mesh.meshManagerApi.loadMeshNetwork();
    final result = await network.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
    debugPrint('provisioner added : $result');
    return result;
  }

  Future<ProvisionedMeshNode> provisioning(DiscoveredDevice device, String serviceDataUuid) async {
    final bleMeshManager = BleMeshManager();
    bleMeshManager.callbacks = MyBleCallbacks(bleMeshManager); // must be set

    final network = await meshManager.mesh.meshManagerApi.loadMeshNetwork();
    final result = await network.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
    debugPrint('provisioner added : $result');
    return await meshManager.mesh
        .provisioning(meshManager.mesh.meshManagerApi, bleMeshManager, device, serviceDataUuid);
  }

  Future<void> doMagic() async {
    print('Doing magic...');
    _counter++;
    notifyListeners();
  }

  Future<bool> startConnection() async {
    print('Starting connection...');
    return true;
  }
}

class MyBleCallbacks extends BleMeshManagerCallbacks {
  MyBleCallbacks(this.bleMeshManager);

  final BleMeshManager bleMeshManager;

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) async {
    print('MTU: $mtu');
  }
}
