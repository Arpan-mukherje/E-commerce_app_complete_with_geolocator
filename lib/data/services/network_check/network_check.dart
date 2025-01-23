import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  RxBool isConnected = false.obs;
  late Stream<bool> connectivityStream;

  @override
  void onInit() {
    super.onInit();
    connectivityStream = Connectivity()
        .onConnectivityChanged
        .map((event) => ConnectivityUtility.checkConnectivity(event));
    connectivityStream.listen((status) {
      isConnected.value = status;
    });
  }
}

class ConnectivityUtility {
  static bool checkConnectivity(List<ConnectivityResult> results) {
    for (var result in results) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.ethernet:
        case ConnectivityResult.mobile:
          return true;
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.none:
        default:
          continue;
      }
    }
    return false;
  }
}
