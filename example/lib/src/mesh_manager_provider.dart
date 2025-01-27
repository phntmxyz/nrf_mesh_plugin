import 'package:flutter/cupertino.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class MeshManagerNotifier extends ChangeNotifier {
  MeshManagerNotifier(this.mesh);

  final NordicNrfMesh mesh;
}
