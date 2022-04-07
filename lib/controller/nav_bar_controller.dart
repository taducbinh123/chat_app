import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class NavBarController extends GetxController {
  var _selectedIndex = 0.obs;

  set selectedIndex(value) => this._selectedIndex.value = value;
  get selectedIndex => this._selectedIndex.value;

  @override
  void onInit() {
    _selectedIndex = 0.obs;
    super.onInit();
  }

  onItemTapped(int index) {
    this.selectedIndex =
        index; // The set method is accessed this way, you have confused it with methods.
  }
}
