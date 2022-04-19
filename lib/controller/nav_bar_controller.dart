import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_world_flutter/controller/qr_controller.dart';


class NavBarController extends GetxController {
  var _selectedIndex = 0.obs;

  set selectedIndex(value) => this._selectedIndex.value = value;
  get selectedIndex => this._selectedIndex.value;
  final qrController = Get.put(QRController());

  @override
  void onInit() {
    _selectedIndex = 0.obs;
    qrController.controllerCountdown.pause();
    super.onInit();
  }

  @override
  onClose() {
    _selectedIndex = 0.obs;
    super.onClose();
  }

  onItemTapped(int index) {
    this.selectedIndex =
        index;// The set method is accessed this way, you have confused it with methods.
    // final QRController qrController = Get.find();
    if(index!=3) qrController.controllerCountdown.pause();

    if(index==3) qrController.controllerCountdown.restart();
  }
}
